variable "subnet" {}
variable "next_hop_ip" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = string
}