provider "google" {
    credentials = file("./google/credentials.json")
    project = var.gcp_project_id
    region = var.gcp_region
    zone = var.gcp_zone
}

provider "cloudflare" {
  email = var.cloudflare_email
  account_id = var.cloudflare_account_id
  api_key = var.cloudflare_token
}

data "google_client_config" "default" {}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.app_server.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.app_server.master_auth.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host  = "https://${google_container_cluster.app_server.endpoint}" 
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.app_server.master_auth.0.cluster_ca_certificate)
}

provider "random" {
  
}
