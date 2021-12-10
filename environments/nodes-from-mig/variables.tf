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
variable "ssh_key" {
  type    = string
  default = ""
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