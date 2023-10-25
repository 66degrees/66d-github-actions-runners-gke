module "my-app-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = google_service_account.gh_sa.account_id
  use_existing_gcp_sa = true
  namespace           = kubernetes_namespace.runner_namespace.metadata.0.name
  project_id          = var.gke_project_id
  #roles               = var.gke_sa_iam_bindings
  depends_on = [google_container_node_pool.gh_runner_np]
}