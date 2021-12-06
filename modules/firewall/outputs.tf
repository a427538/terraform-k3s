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


output "firewall_rule_ssh" {
  value = "${google_compute_firewall.ssh.name}"
}

output "firewall_rule_internal" {
  value = "${google_compute_firewall.internal.name}"
}
 
output "firewall_rule_master" {
  value = "${google_compute_firewall.master.name}"
}

output "firewall_rule_ingress" {
  value = "${google_compute_firewall.ingress.name}"
}

