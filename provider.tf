provider "google" {
    credentials = file("./google/credentials.json")
    project = var.project_name
    region = var.region
    zone = var.zone
}
