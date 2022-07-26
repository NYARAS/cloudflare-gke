resource "google_compute_subnetwork" "app_server_vpc_subnet" {
  name = var.app_server_subnet_name
  ip_cidr_range = "10.10.10.0/24"
  network = google_compute_network.app_server_vpc.id
  region = var.gcp_region

  secondary_ip_range = [
    {
        range_name = "services"
        ip_cidr_range = "10.10.11.0/24"
    },
    {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/20"
    }
  ]

   private_ip_google_access = true

}
