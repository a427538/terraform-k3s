# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  network = "${element(split("-", var.subnet), 0)}"
}

# resource "google_compute_firewall" "allow-http" {
#   name    = "${local.network}-allow-http"
#   network = "${local.network}"
#   project = "${var.project}"
# 
#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }
# 
#   target_tags   = ["http-server"]
#   source_ranges = ["0.0.0.0/0"]
# }

resource "google_compute_firewall" "ssh" {
  name      = "${local.network}-ssh"
  network   = "${local.network}"
  direction = "INGRESS"
  project   = var.project
  source_ranges = var.allowed_ips
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["${var.group_name}-${var.env}-master", "${var.group_name}-${var.env}-worker"]
}

resource "google_compute_firewall" "internal" {
  name          = "${local.network}-internal"
  network       = "${local.network}"
  direction     = "INGRESS"
  project       = var.project
  source_ranges = [var.ip_cidr_range]
  
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "master" {
  name          = "${local.network}-master"
  network       = "${local.network}"
  direction     = "INGRESS"
  project       = var.project
  source_ranges = var.allowed_ips

  allow {
    protocol = "tcp"
    ports    = ["80", "6443"]
  }
  target_tags = ["${var.group_name}-${var.env}-master"]
}

resource "google_compute_firewall" "ingress" {
  name      = "${local.network}-ingress"
  network   = "${local.network}"
  direction = "INGRESS"
  project   = var.project
  source_ranges = [
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "108.162.192.0/18",
    "131.0.72.0/22",
    "141.101.64.0/18",
    "162.158.0.0/15",
    "172.64.0.0/13",
    "173.245.48.0/20",
    "188.114.96.0/20",
    "190.93.240.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "0.0.0.0/0"
  ]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["${var.group_name}-${var.env}-worker"]
}

# Add default route for internal VMs with no external IP address
resource "google_compute_route" "default" {
  name        = "default"
  depends_on = [ var.nat_router]
  tags        = [ "no-ip" ]
  dest_range  = "0.0.0.0/0"
  network       = "${local.network}"
  next_hop_ip = var.nat_router.network_interface[0].network_ip
  priority    = 800
}