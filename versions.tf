terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.19.0"
    }

        cloudflare = {
      source = "cloudflare/cloudflare"
    }
    random = {
      source = "hashicorp/random"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }


  # backend "gcs" {
  #   bucket      = "heavenland-nft-gke-tfstate"
  #   prefix      = "nft/terraform/state"
  #   credentials = "google/credentials.json"
  # }
}
