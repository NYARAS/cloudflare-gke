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

variable "router_name" {
  description = "GCP router name"
  default = "appserver-router"
}

variable "router_nat_name" {
  description = "GCP router nat name"
  default = "appserver-router-nat"
}
variable "compute_address_name" {
  description = "GCP computer address name"
  default = "appserver-compute-address"
}
variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "devops-cluster"
}

variable "node_machine_type" {
  type        = string
  description = "GCP node pool machine type to use."
  default     = "e2-small"
}
## VPC Variables
variable "app_server_vpc_name" {
  description = "GCP VPC name."
  type = string
}

variable "app_server_subnet_name" {
  description = "GCP subnet name."
  type = string
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network"
  type        = string
  default     = "192.168.0.0/28"
}

variable "service_account_name" {
  description = "GCP service account name."
  type        = string
  default     = "app-server-sa"
}

variable "nodepool_name" {
  description = "Kubernetes node pool name."
  type = string
  default = "appserver"
}

# Cloudflare Variables
variable "cloudflare_zone" {
  description = "The Cloudflare Zone to use."
  type        = string
}

variable "cloudflare_account_id" {
  description = "The Cloudflare UUID for the Account the Zone lives in."
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "The Cloudflare user."
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "The Cloudflare user's API token."
  type        = string
}

variable "zone_dns_edit_name" {
  type = string
  default = "appserver-dns-edit"
}
variable "cloudflare_argo_tunnel_name" {
  type = string
  default = "appserver-tunnel"
}
