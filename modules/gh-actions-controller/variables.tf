variable "gke_location" {
  type        = string
  description = "Location of the GKE cluster"
}
variable "gke_name" {
  type        = string
  description = "Name of the GKE cluster"
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
}

variable "gke_np_min_nodes" {
  type        = number
  description = "Min no. of nodes in the nodepool"
}

variable "repo_name" {
  type        = string
  description = "Name of the Github repository that requires self hosted runners for running builds"
}

variable "github_pat" {
  type        = string
  description = "The GitHub Personal Access Token"
}

variable "gke_sa_iam_bindings" {
  type        = list(string)
  description = "List of roles that needs to be assigned to the GKE service account"
}

# Artifact Registry repository
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

variable "namespace" {
  type        = string
  description = "Namespace name for deploying the Runner deployments"
}

variable "service_account_name" {
  type        = string
  description = "Name of the service account to be created for GKE workload Identity (the part before @)"
}