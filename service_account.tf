resource "google_service_account" "service_account" {
  account_id = var.service_account_name
  display_name = "Service Account for Pulling images from GCR"
}

resource "google_project_iam_member" "storage_viewer" {
  count = 1
  project = var.gcp_project_id
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "artifact_reader" {
  count = 1
  project = var.gcp_project_id
    role = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.service_account.email}"
}
