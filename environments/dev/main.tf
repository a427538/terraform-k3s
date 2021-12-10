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
  env = "dev"
}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project_id
  region = var.region
  ip_cidr_range = "${var.ip_cidr_range}"
  ip_cidr_second_range = "${var.ip_cidr_second_range}"
  group_name = "${var.group_name}"
  env     = local.env
}

# module "http_server" {
#   source  = "../../modules/http_server"
#   project = "${var.project_id}"
#   subnet  = "${module.vpc.subnet}"
# }

module "firewall" {
  env = local.env
  source  = "../../modules/firewall"
  project = "${var.project_id}"
  subnet  = "${module.vpc.subnet}"
  group_name = "${var.group_name}"
  allowed_ips = "${var.allowed_ips}"
  ip_cidr_range = "${var.ip_cidr_range}"
}

module "k3s-master" {
  env     = local.env
  branch  = "${var.branch}"    
  source  = "../../modules/k3s-master"
  project = "${var.project_id}"
  subnet  = "${module.vpc.subnet}"
  group_name = "${var.group_name}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  boot_image = "${var.boot_image}"
  disk_size = "${var.disk_size}"
  ssh_keys = "${var.ssh_keys}"
}

module "k3s-worker" {
  env     = local.env
  branch  = "${var.branch}"
  source  = "../../modules/k3s-worker"
  project = "${var.project_id}"
  region = "${var.region}"
  subnet  = "${module.vpc.subnet}"
  group_name = "${var.group_name}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  boot_image = "${var.boot_image}"
  disk_size = "${var.disk_size}"
  ssh_keys = "${var.ssh_keys}"
  token = "${module.k3s-master.k3s_master_joining_token.result}"
  server_address = "${module.k3s-master.external_ip}"
}