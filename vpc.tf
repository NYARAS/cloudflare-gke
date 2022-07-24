resource "google_compute_network" "app_server_vpc" {
  name = var.app_server_vpc_name
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}
