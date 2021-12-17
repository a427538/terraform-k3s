locals {
  network = "${element(split("-", var.subnet), 0)}"
}

data "template_file" "worker" {
  template = file("./scripts/worker.sh")
  vars = {
    token          = "${var.token}"
    server_address = "${var.server_address}"
    branch         = "${var.branch}"
  }
}

resource "google_service_account" "default" {
  account_id   = "sa-${var.group_name}-${var.env}-worker"
  display_name = "Service Account K3S Worker"
}

resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "${var.group_name}-${var.env}-worker-"
  description = "This template is used to create k3s worker instances."

  instance_description = "${var.group_name}-${var.env}-worker K3S worker instances"
  machine_type = "${var.machine_type}"
  region       = "${var.region}"
  can_ip_forward       = true

  scheduling {
    preemptible = true
    automatic_restart   = false
    # on_host_maintenance = "MIGRATE"
  }

  // boot disk
  disk {
    source_image = "${var.boot_image}"
    // type         = "pd-standard"
    auto_delete  = true
    boot         = true
    disk_size_gb = "${var.disk_size}"
  }

  network_interface {
    subnetwork = "${var.subnet}"
    # access_config {
    #   network_tier = "PREMIUM"
    # }
  }

  tags = ["${var.group_name}-${var.env}-worker", "no-ip"]

  metadata = {
    ssh-keys = join("\n", [for key in var.ssh_keys : "${key.user}:${key.publickey}"])
  }

  labels = {
    environment = "dev"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = data.template_file.worker.rendered
  # depends_on = [module.k3s-master.google_compute_instance.master]  
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  version {
    instance_template  = google_compute_instance_template.instance_template.id
  }
  base_instance_name = "${var.group_name}-${var.env}-worker"
  zone               = "${var.zone}"
  target_size        = "1"
}

resource "google_compute_autoscaler" "default" {
  provider = google-beta

  name   = "${var.group_name}-${var.env}-autoscaler"
  zone         = var.zone
  project      = var.project
  target = google_compute_instance_group_manager.instance_group_manager.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}