locals {
  region = length(var.repository_location) == 2 ? "global" : var.repository_location
}

# Creates Artifact Registry repository
resource "google_artifact_registry_repository" "gh_repo" {
  project       = var.repository_project_id
  location      = var.repository_location
  repository_id = var.repository_id

  description = "Terraform managed repository for holding custom gh-runner image"
  format      = "DOCKER"
}

# Pulls all public images used in the helm charts and pushes it to Artifact Registry
resource "null_resource" "custom_images" {
  count = length(var.base_images)
  triggers = {
    on_change = var.base_images[count.index].source
    on_change = var.base_images[count.index].image
  }
  provisioner "local-exec" {
    command = <<EOT
      gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://${var.repository_location}-docker.pkg.dev
      docker pull ${var.base_images[count.index].source}
      docker tag ${var.base_images[count.index].source} ${var.repository_location}-docker.pkg.dev/${var.repository_project_id}/${google_artifact_registry_repository.gh_repo.name}/${var.base_images[count.index].image}
      docker push ${var.repository_location}-docker.pkg.dev/${var.repository_project_id}/${google_artifact_registry_repository.gh_repo.name}/${var.base_images[count.index].image}
  EOT
  }
}

resource "null_resource" "gh_runner_image" {
  triggers = {
    on_change = file("./modules/custom-images/Dockerfile")
  }
  provisioner "local-exec" {
    command = <<EOT
      gcloud builds submit ./modules/custom-images --project ${var.repository_project_id} --region=${local.region} --tag ${var.repository_location}-docker.pkg.dev/${var.repository_project_id}/${google_artifact_registry_repository.gh_repo.name}/custom-runner-deployment
  EOT
  }
}

# Builds custom image for runner-deployment by installing additional components
#module "gcloud" {
#  source  = "terraform-google-modules/gcloud/google"
#  version = "3.1.2"
#
#  platform = "linux"
#
#  create_cmd_entrypoint  = "gcloud"
#  create_cmd_body        = "builds submit ./modules/docker-image --project ${var.repository_project_id} --region=${local.region} --tag ${var.repository_location}-docker.pkg.dev/${var.repository_project_id}/${google_artifact_registry_repository.gh_repo.name}/custom-runner-deployment"
#
#}