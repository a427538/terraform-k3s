# Add a record to the domain
resource "cloudflare_record" "foobar" {
  zone_id = var.cloudflare_zone_id
  name    = "api.k3s"
  value   = module.k3s-master.external_ip
  type    = "A"
  ttl     = 3600
}