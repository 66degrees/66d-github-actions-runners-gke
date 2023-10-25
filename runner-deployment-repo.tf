resource "kubernetes_manifest" "runner_autoscaler" {
  manifest = yamldecode(<<-EOF
    apiVersion: actions.summerwind.dev/v1alpha1
    kind: HorizontalRunnerAutoscaler
    metadata:
      name: ${var.runner_deployment_name}-autoscaler
      namespace: ${module.gh_actions_controller.runner_namespace}
    spec:
      # Runners in the targeted RunnerDeployment won't be scaled down
      # for 5 minutes instead of the default 10 minutes now
      scaleDownDelaySecondsAfterScaleOut: 300
      scaleTargetRef:
        kind: RunnerDeployment
        name: ${var.runner_deployment_name}
      minReplicas: ${var.runner_autoscaler_min_replicas}
      maxReplicas: ${var.runner_autoscaler_max_replicas}
      metrics:
      - type: PercentageRunnersBusy
        scaleUpThreshold: '0.75'
        scaleDownThreshold: '0.25'
        scaleUpFactor: '2'
        scaleDownFactor: '0.5'
    EOF
  )
  depends_on = [module.gh_actions_controller]
}
#Deploys the Runner Deployment manifest for a repository
resource "kubernetes_manifest" "runner_deployment" {
  manifest = yamldecode(<<-EOF
    apiVersion: actions.summerwind.dev/v1alpha1
    kind: RunnerDeployment
    metadata:
      name: ${var.runner_deployment_name}
      namespace: ${module.gh_actions_controller.runner_namespace}
    spec:
      template:
        spec:
          repository: ${var.repo_name}
          image: "${local.artifact_registry_repository}/custom-runner-deployment"
          serviceAccountName: ${var.service_account_name}
          nodeSelector:
            purpose: ${local.node_selector_label_value}
          labels:
            - gke-runner
          resources:
            requests:
              cpu: "100m"
              memory: "256Mi"
            limits:
              cpu: "200m"
              memory: "512Mi"
    EOF
  )
  depends_on = [module.gh_actions_controller]
}