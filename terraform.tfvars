# Github actions controller variables
gke_location         = "us-central1-c"
gke_name             = "cluster-1"
gke_project_id       = "<YOUR-PROJECT-ID>"
gke_np_machine_type  = "e2-medium"
gke_np_max_nodes     = 4
gke_np_min_nodes     = 1
repo_name            = "<REPO-OWNER>/<REPO-NAME>"
secret_name          = "github_pat"
secret_project_id    = "<YOUR-PROJECT-ID>"
gke_sa_iam_bindings  = ["roles/editor", "roles/artifactregistry.admin", "roles/secretmanager.secretAccessor"]
service_account_name = "gh-arc-sa"

# Artifact registry variables
repository_location   = "us"
repository_id         = "gh-repo"
repository_project_id = "<YOUR-PROJECT-ID>"

# Runner Deployment and autoscaler variables
runner_autoscaler_min_replicas = 1
runner_autoscaler_max_replicas = 3
runner_deployment_name         = "gh-runner-deployment"
namespace                      = "github-runner"
