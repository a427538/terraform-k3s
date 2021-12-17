# Add default route for internal VMs with no external IP address
resource "google_compute_route" "default" {
  name        = "default"
  # depends_on = [ var.next_hop_ip ]
  tags        = [ "no-ip" ]
  dest_range  = "0.0.0.0/0"
  network       = "${local.network}"
  next_hop_ip = var.next_hop_ip
  priority    = 800
}