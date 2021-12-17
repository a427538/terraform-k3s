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


output "network" {
  value = "${module.vpc.network}"
}

output "subnet" {
  value = "${module.vpc.subnet}"
}

output "firewall_rules" {
  value = [
    "${module.firewall.firewall_rule_ssh}",
    "${module.firewall.firewall_rule_internal}",
    "${module.firewall.firewall_rule_master}",
    "${module.firewall.firewall_rule_ingress}",
  ]
}

output "k3s_master_instance_name" {
  value = "${module.k3s-master.instance_name}"
}

output "k3s_master_internal_ip" {
  value = "${module.k3s-master.internal_ip}"
}

output "k3s_master_external_ip" {
  value = "${module.k3s-master.external_ip}"
}

output "k3s_master_joining_token" {
  value = "${module.k3s-master.k3s_master_joining_token}"
}
