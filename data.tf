data "google_container_cluster" "gke_cluster" {
  project  = var.gke_project_id
  name     = var.gke_name
  location = var.gke_location
}

data "google_client_config" "default" {}
