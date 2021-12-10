locals {
  network = "${element(split("-", var.subnet), 0)}"
}

resource "random_string" "token" {
  length           = 108
  special          = true
  number           = true
  lower            = true
  upper            = true
  override_special = ":"
}


data "template_file" "master" {
  template = file("../../environments/${var.env}/scripts/master.sh")
  vars = {
    token                  = random_string.token.result
    external_lb_ip_address = google_compute_address.master.address
    branch = "${var.branch}"

    // Uncomment if you're using database
    /* db_username            = google_sql_user.storage.name
    db_password            = google_sql_user.storage.password
    db_host                = google_sql_database_instance.storage.private_ip_address */
  }
}

resource "google_compute_address" "master" {
  name         = "eip-${var.group_name}-${var.env}"
  network_tier = "PREMIUM"
}

resource "google_compute_instance" "master" {
  machine_type = var.machine_type
  name         = "${var.group_name}-${var.env}-master"
  zone         = var.zone
  project      = var.project

  boot_disk {
    initialize_params {
      image = var.boot_image
      type  = "pd-standard"
      size  = var.disk_size
    }
  }
  tags = ["${var.group_name}-${var.env}-master"]

  network_interface {
    subnetwork = "${var.subnet}"
    access_config {
      nat_ip = google_compute_address.master.address
    }
  }

  metadata = {
    ssh-keys = join("\n", [for key in var.ssh_keys : "${key.user}:${key.publickey}"])
  }
  metadata_startup_script = data.template_file.master.rendered
}
