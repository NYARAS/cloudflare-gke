resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.gcp_region
  network = google_compute_network.app_server_vpc.id
}

resource "google_compute_router_nat" "router_nat" {
  name   = var.router_nat_name
  router = google_compute_router.router.name
  region = var.gcp_region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.app_server_vpc_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.compute_address.self_link]
}

resource "google_compute_address" "compute_address" {
  name         = var.compute_address_name
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}
