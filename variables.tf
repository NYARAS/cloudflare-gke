variable "gcp_project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string
}

variable "gcp_region" {
  description = "GCP region to create the resources"
  default = "europe-west1"
}

variable "gcp_zone" {
  description = "GCP zone to create the resources"
  default = "europe-west1-c"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "devops-cluster"
}
