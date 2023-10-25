# GitHub Actions Self Hosted Runners on GKE
This repository contains Terraform scripts for setting up the infrastructure required to deploy self-hosted runners on GKE.

Imp notes: 
1. This code assumes you already have a GKE cluster up and running with Workload Identity enabled at CLUSTER level, hence it DOES NOT create a new GKE cluster. It only adds a new node pool to the existing GKE cluster. Information about the existing GKE cluster can be passed to the Terraform scripts via the tfvars file.
2. Do not remove the labels and node selectors values for the nodepools and helm charts. These have been designed in a way so that all the deployments would get deployed to the desired nodepools.
3. User running this code should have the following roles at minimum:
   - Artifact Registry admin
   - GKE admin
   - Service Account Admin
   - Project IAM Admin

## How to use the Terraform scripts

1. Clone the repository
2. Create a Github Personal Access Token(PAT). Personal Access Tokens can be used to register a self-hosted runner by actions-runner-controller. Create a Personal Access Token by following the steps below:
  - Login to your GitHub account, locate the  "Create new Token." button
  - Select repo.
  - Click Generate Token and then copy the token locally ( we’ll need it in the next step).
3. Create a secret in Secret Manager with the GitHub PAT that we created in the previous step as its value.
4. Optional - Go to the Dockerfile that is present in the modules/custom-image directory. Modify it according to your requirements.
5. Update the values of variables in the .tfvars file. You can refer to the README file for descriptions about the variables.
6. Execute the Terraform scripts using the following commands-
  - terraform init
  - terraform plan
  - terraform apply --target=module.docker_image --target=module.gh_actions_controller
  - terraform apply

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_location"></a> [gke\_location](#input\_gke\_location) | Location of the GKE cluster | `string` | n/a | yes |
| <a name="input_gke_name"></a> [gke\_name](#input\_gke\_name) | Name of the existing GKE cluster | `string` | n/a | yes |
| <a name="input_gke_np_machine_type"></a> [gke\_np\_machine\_type](#input\_gke\_np\_machine\_type) | Machine type for the nodepool | `string` | n/a | yes |
| <a name="input_gke_np_max_nodes"></a> [gke\_np\_max\_nodes](#input\_gke\_np\_max\_nodes) | Max no. of nodes in the nodepool | `number` | `5` | no |
| <a name="input_gke_np_min_nodes"></a> [gke\_np\_min\_nodes](#input\_gke\_np\_min\_nodes) | Min no. of nodes in the nodepool | `number` | `1` | no |
| <a name="input_gke_project_id"></a> [gke\_project\_id](#input\_gke\_project\_id) | Project ID where the GKE cluster resides | `string` | n/a | yes |
| <a name="input_gke_sa_iam_bindings"></a> [gke\_sa\_iam\_bindings](#input\_gke\_sa\_iam\_bindings) | List of roles that needs to be assigned to the GKE service account | `list(string)` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name for deploying the Runner deployments | `string` | `"github-runner"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the Github repository whose workflows will use self hosted runners for running builds | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | The last part of the Artifact Registry repository name, for example: repo1 | `string` | n/a | yes |
| <a name="input_repository_location"></a> [repository\_location](#input\_repository\_location) | The name of the location this repository is located in | `string` | n/a | yes |
| <a name="input_repository_project_id"></a> [repository\_project\_id](#input\_repository\_project\_id) | The ID of the project in which the repository belongs | `string` | n/a | yes |
| <a name="input_runner_autoscaler_max_replicas"></a> [runner\_autoscaler\_max\_replicas](#input\_runner\_autoscaler\_max\_replicas) | Maximum number of replicas for the HorizontalRunnerAutoscaler resource | `number` | `5` | no |
| <a name="input_runner_autoscaler_min_replicas"></a> [runner\_autoscaler\_min\_replicas](#input\_runner\_autoscaler\_min\_replicas) | Minimum number of replicas for the HorizontalRunnerAutoscaler resource | `number` | `1` | no |
| <a name="input_runner_deployment_name"></a> [runner\_deployment\_name](#input\_runner\_deployment\_name) | Name of the RunnerDeployment resource | `string` | `"gh-runner-deployment"` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name of the secret that contains GitHub PAT | `string` | n/a | yes |
| <a name="input_secret_project_id"></a> [secret\_project\_id](#input\_secret\_project\_id) | Project ID where the GitHub PAT secret resides | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account to be created for GKE Workload Identity (the part before @) | `string` | `"gh-arc-sa"` | no |

