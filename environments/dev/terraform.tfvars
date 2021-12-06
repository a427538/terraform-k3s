group_name = "k3s"
ip_cidr_range = "10.0.0.0/16"
ip_cidr_second_range = "10.1.0.0/16"
project_id = "free-tier-1"
credentials = "~/.config/gcloud/sa-terraform.free-tier-1.json"
service_account = {
  email = "sa-terraform@free-tier-1.iam.gserviceaccount.com"
  scopes = ["default"]
}