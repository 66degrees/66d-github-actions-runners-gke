locals {
  artifact_registry_repository = "${var.repository_location}-docker.pkg.dev/${var.repository_project_id}/${var.repository_id}"
  node_selector_label_value    = "github-runners"
}