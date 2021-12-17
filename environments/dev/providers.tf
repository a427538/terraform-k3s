provider "google" {
  # credentials = file(var.credentials)    
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}