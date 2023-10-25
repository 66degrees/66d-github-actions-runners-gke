variable "repository_location" {
  description = "The name of the location this repository is located in"
  type        = string
}

variable "repository_id" {
  description = "The last part of the repository name, for example: repo1"
  type        = string
}

variable "repository_project_id" {
  description = "The ID of the project in which the repository belongs"
  type        = string
}

variable "base_images" {
  default = [{
    source = "summerwind/actions-runner-controller"
    image  = "actions-runner-controller"
    },
    {
      source = "quay.io/brancz/kube-rbac-proxy:v0.13.1"
      image  = "kube-rbac-proxy"
    },
    {
      source = "quay.io/jetstack/cert-manager-controller:v1.12.4"
      image  = "cert-manager-controller"
    },
    {
      source = "quay.io/jetstack/cert-manager-webhook:v1.12.4"
      image  = "cert-manager-webhook"
    },
    {
      source = "quay.io/jetstack/cert-manager-cainjector:v1.12.4"
      image  = "cert-manager-cainjector"
    },
    {
      source = "quay.io/jetstack/cert-manager-acmesolver:v1.12.4"
      image  = "cert-manager-acmesolver"
    },
    {
      source = "quay.io/jetstack/cert-manager-ctl:v1.12.4"
      image  = "cert-manager-ctl"
    }
  ]
  type = list(object({
    source = string
    image  = string
  }))
}