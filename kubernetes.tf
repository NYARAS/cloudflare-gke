resource "google_container_cluster" "app_server" {
  name                     = var.cluster_name
  location                 = "${var.gcp_region}-b"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.app_server_vpc.self_link
  subnetwork               = google_compute_subnetwork.app_server_vpc_subnet.self_link
  networking_mode          = "VPC_NATIVE"

  node_locations = [
    "${var.gcp_region}-c"
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project_id}.svc.id.goog"
  }

### NOTE: The names here should match the ones defined in subnets secondary_ip_range
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

}
