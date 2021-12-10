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


variable "project" {}
variable "subnet" {}
variable "env" {}
variable "group_name" {}
variable "machine_type" {}
variable "zone" {}
variable "boot_image" {}
variable "disk_size" {}
variable "ssh_keys" {
  type = list(object({
    publickey = string
    user = string
  }))
  description = "list of public ssh keys that have access to the VM"
  default =[]    
}
variable "token" {}
variable "server_address" {}
variable "region" {}
variable "branch" {
  type = string
}