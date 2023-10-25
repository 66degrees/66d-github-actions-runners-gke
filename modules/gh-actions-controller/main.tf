locals {
  artifact_registry_repository = "${var.repository_location}-docker.pkg.dev/${var.repository_project_id}/${var.repository_id}"
  node_selector_label_value    = "github-runners"
}

## Creates a service account for Workload Identity
resource "google_service_account" "gh_sa" {
  project      = var.gke_project_id
  account_id   = var.service_account_name
  display_name = "Service Account for Workload Identity"
}

# Creates IAM bindings at project level
resource "google_project_iam_member" "sa_project_bindings" {
  for_each = toset(var.gke_sa_iam_bindings)

  project = var.gke_project_id
  role    = each.value
  member  = google_service_account.gh_sa.member
}

# Creates nodepool for Github runners to run into
resource "google_container_node_pool" "gh_runner_np" {
  name    = "gh-runner-node-pool"
  cluster = data.google_container_cluster.gke_cluster.id
  autoscaling {
    max_node_count = var.gke_np_max_nodes
    min_node_count = var.gke_np_min_nodes
  }
  node_config {
    machine_type    = var.gke_np_machine_type
    service_account = google_service_account.gh_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      purpose = local.node_selector_label_value
    }
  }
  timeouts {
    create = "30m"
    update = "20m"
  }
}

# Deploys Cert Manager helm chart
resource "helm_release" "cert-manager" {
  chart            = "./helm-charts/cert-manager"
  create_namespace = true
  force_update     = true
  name             = "cert-manager"
  namespace        = "cert-manager"
  timeout          = 600
  wait             = true

  set {
    name  = "installCRDs"
    value = true
  }

  values = [
    <<EOT
    image:
      repository: ${local.artifact_registry_repository}/cert-manager-controller
      tag: latest
    nodeSelector:
      purpose: ${local.node_selector_label_value}
    startupapicheck:
      image:
        repository: ${local.artifact_registry_repository}/cert-manager-ctl
        tag: latest
      nodeSelector:
        purpose: ${local.node_selector_label_value}
    cainjector:
      nodeSelector:
        purpose: ${local.node_selector_label_value}
      image:
        repository: ${local.artifact_registry_repository}/cert-manager-cainjector
        tag: latest
    webhook:
      nodeSelector:
        purpose: ${local.node_selector_label_value}
      image:
        repository: ${local.artifact_registry_repository}/cert-manager-webhook
        tag: latest
    acmesolver:
      image:
        repository: ${local.artifact_registry_repository}/cert-manager-acmesolver
        tag: latest
      nodeSelector:
        purpose: ${local.node_selector_label_value}
    EOT
  ]
}

# Deploys the helm chart
resource "helm_release" "actions-runner-controller" {
  chart            = "./helm-charts/actions-runner-controller"
  create_namespace = true
  namespace        = "actions-runner-system"
  force_update     = true
  name             = "actions-runner-controller"
  timeout          = 600
  wait             = true

  set {
    name  = "authSecret.create"
    value = true
  }

  set {
    name  = "authSecret.github_token"
    value = var.github_pat
  }

  values = [
    # Passing the nodeselector values so that the pods are deployed to the newly created nodepool
    <<EOT
    nodeSelector:
      purpose: ${local.node_selector_label_value}
    image:
      repository: "${local.artifact_registry_repository}/actions-runner-controller"
      tag: latest
      actionsRunnerRepositoryAndTag: "${local.artifact_registry_repository}/custom-runner-deployment"
    metrics:
      proxy:
        image:
          repository: ${local.artifact_registry_repository}/kube-rbac-proxy
          tag: latest
    actionsMetrics:
      proxy:
        image:
          repository: ${local.artifact_registry_repository}/kube-rbac-proxy
          tag: latest
    actionsMetricsServer:
      nodeSelector:
        purpose: ${local.node_selector_label_value}
    githubWebhookServer:
      nodeSelector:
        purpose: ${local.node_selector_label_value}
    EOT
  ]

  depends_on = [helm_release.cert-manager]
}

# Creates namespace for Runner Deployment
resource "kubernetes_namespace" "runner_namespace" {
  metadata {
    name = var.namespace
  }
}