output "runner_namespace" {
  value = kubernetes_namespace.runner_namespace.metadata.0.name
}