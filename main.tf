data "google_secret_manager_secret_version" "github_pat" {
  project = var.secret_project_id
  secret  = var.secret_name
}

module "docker_image" {
  source                = "./modules/custom-images"
  repository_location   = var.repository_location
  repository_id         = var.repository_id
  repository_project_id = var.repository_project_id
}

module "gh_actions_controller" {
  source               = "./modules/gh-actions-controller"
  gke_location         = var.gke_location
  gke_name             = var.gke_name
  gke_project_id       = var.gke_project_id
  repo_name            = var.repo_name
  github_pat           = data.google_secret_manager_secret_version.github_pat.secret_data
  gke_sa_iam_bindings  = var.gke_sa_iam_bindings
  gke_np_machine_type  = var.gke_np_machine_type
  gke_np_max_nodes     = var.gke_np_max_nodes
  gke_np_min_nodes     = var.gke_np_min_nodes
  service_account_name = var.service_account_name

  repository_id         = var.repository_id
  repository_location   = var.repository_location
  repository_project_id = var.repository_project_id
  namespace             = var.namespace

  depends_on = [module.docker_image]
}