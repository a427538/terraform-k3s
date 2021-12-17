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


module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "3.3.0"

  project_id   = "${var.project}"
  network_name = "${var.env}"
  routing_mode = "REGIONAL"  

  subnets = [
    {
      subnet_name   = "${var.env}-subnet-01"
      subnet_ip     = "${var.ip_cidr_range}"
      subnet_region = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    },
  ]

  secondary_ranges = {
    "${var.env}-subnet-01" = [
      {
        range_name    = "${var.env}-subnet-01-second-range"
        ip_cidr_range = var.ip_cidr_second_range
      }        
    ]
  }
}

# Add default route for internal VMs with no external IP address
resource "google_compute_route" "default" {
  name        = "default"
  depends_on = [google_compute_instance.master]
  tags        = [ "no-ip" ]
  dest_range  = "0.0.0.0/0"
  network     = google_compute_network.vpc.name
  next_hop_ip = google_compute_instance.master.network_interface[0].network_ip
  priority    = 800
}
