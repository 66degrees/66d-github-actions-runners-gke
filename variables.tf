variable "repo_name" {
  type        = string
  description = "Name of the Github repository whose workflows will use self hosted runners for running builds"
}

variable "gke_location" {
  type        = string
  description = "Location of the GKE cluster"
}

variable "gke_name" {
  type        = string
  description = "Name of the existing GKE cluster"
}

variable "gke_project_id" {
  type        = string
  description = "Project ID where the GKE cluster resides"
}

variable "gke_np_machine_type" {
  type        = string
  description = "Machine type for the nodepool"
}

variable "gke_np_max_nodes" {
  type        = number
  description = "Max no. of nodes in the nodepool"
  default     = 5
}

variable "gke_np_min_nodes" {
  type        = number
  description = "Min no. of nodes in the nodepool"
  default     = 1
}

variable "service_account_name" {
  type        = string
  description = "Name of the service account to be created for GKE Workload Identity (the part before @)"
  default     = "gh-arc-sa"
}

variable "secret_project_id" {
  type        = string
  description = "Project ID where the GitHub PAT secret resides"
}

variable "secret_name" {
  type        = string
  description = "Name of the secret that contains GitHub PAT"
}

variable "gke_sa_iam_bindings" {
  type        = list(string)
  description = "List of roles that needs to be assigned to the GKE service account"
}

#Artifact registry repository variables
variable "repository_location" {
  type        = string
  description = "The name of the location this repository is located in"
}

variable "repository_id" {
  type        = string
  description = "The last part of the Artifact Registry repository name, for example: repo1"
}

variable "repository_project_id" {
  type        = string
  description = "The ID of the project in which the repository belongs"
}

variable "runner_autoscaler_min_replicas" {
  type        = number
  description = "Minimum number of replicas for the HorizontalRunnerAutoscaler resource"
  default     = 1
}

variable "runner_autoscaler_max_replicas" {
  type        = number
  description = "Maximum number of replicas for the HorizontalRunnerAutoscaler resource"
  default     = 5
}

variable "runner_deployment_name" {
  type        = string
  description = "Name of the RunnerDeployment resource"
  default     = "gh-runner-deployment"
}

variable "namespace" {
  type        = string
  description = "Namespace name for deploying the Runner deployments"
  default     = "github-runner"
}