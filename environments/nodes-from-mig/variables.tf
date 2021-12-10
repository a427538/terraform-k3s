variable "group_name" {
  type = string
}
variable "machine_type" {
  type    = string
  default = "e2-small"
}
variable "zone" {
  type    = string
  default = "us-east1-b"
}
variable "project_id" {
  type      = string
  sensitive = true
}
variable "region" {
  type    = string
  default = "us-east1"
}
variable "boot_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}
variable "disk_size" {
  type    = number
  default = 50
}
variable "ssh_keys" {
  type = list(object({
    publickey = string
    user = string
  }))
  description = "list of public ssh keys that have access to the VM"
  default = [
      {
        user = "stich_karl"
        publickey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAIQzINOqwkX4PBE79EpaVFNHOzjkfTJUFJCYotSb2QmwAqUTrAzLIKOA2PvaE5RX0H7X5W7lhoTUB5C2CVl1qzqLTFBryp4zVpD2i1pjaoNjqr84bpZBZiZK5mkCXYSloJ/siXPVNBHbd0O07XKp35ITir3XcbV2xBV7ng8TekOvhwNrjec9L22q/+ywL9XkOwA7GKew42bPPV1/0A6ytQVSannhmzr43+mGYEgvvvZaQgWpsAYRvyRV586MRgYxZTHOb++yUM+S4kFv7IP+WueXNCWE93xELwbDKdNJH5l6uwMBBCvbI45yIaG7mYlbYR685QWEbYDNb9WUaGIK5 stich_karl"
      }
  ]
}
variable "total_node" {
  type    = number
  default = 2
}
variable "ip_cidr_range" {
  type = string
}
variable "ip_cidr_second_range" {
  type = string
}
variable "allowed_ips" {
  type = list(string)
  default = ["0.0.0.0/0"]
}
# variable "credentials" {
#   type = string
# }
# variable "service_account" {
#   type = object({ email = string, scopes = set(string) })
# }

variable "branch" {
  type = string
}

variable "cloudflare_email" {
  type = string
}

variable "cloudflare_api_key" {
  type = string
}

variable "cloudflare_zone_id"  {
  type = string
}