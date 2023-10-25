# gh-actions-controller
This module performs the following actions:
- Creates a GKE nodepool
- Creates a custom service account that will be attached to the nodepool
- Enables Workload Identity Federation
- Deploys HELM charts that are required for setting up the ARC

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_pat"></a> [github\_pat](#input\_github\_pat) | The GitHub Personal Access Token | `string` | n/a | yes |
| <a name="input_gke_location"></a> [gke\_location](#input\_gke\_location) | Location of the GKE cluster | `string` | n/a | yes |
| <a name="input_gke_name"></a> [gke\_name](#input\_gke\_name) | Name of the GKE cluster | `string` | n/a | yes |
| <a name="input_gke_np_machine_type"></a> [gke\_np\_machine\_type](#input\_gke\_np\_machine\_type) | Machine type for the nodepool | `string` | n/a | yes |
| <a name="input_gke_np_max_nodes"></a> [gke\_np\_max\_nodes](#input\_gke\_np\_max\_nodes) | Max no. of nodes in the nodepool | `number` | n/a | yes |
| <a name="input_gke_np_min_nodes"></a> [gke\_np\_min\_nodes](#input\_gke\_np\_min\_nodes) | Min no. of nodes in the nodepool | `number` | n/a | yes |
| <a name="input_gke_project_id"></a> [gke\_project\_id](#input\_gke\_project\_id) | Project ID where the GKE cluster resides | `string` | n/a | yes |
| <a name="input_gke_sa_iam_bindings"></a> [gke\_sa\_iam\_bindings](#input\_gke\_sa\_iam\_bindings) | List of roles that needs to be assigned to the GKE service account | `list(string)` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name for deploying the Runner deployments | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the Github repository that requires self hosted runners for running builds | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | The last part of the Artifact Registry repository name, for example: repo1 | `string` | n/a | yes |
| <a name="input_repository_location"></a> [repository\_location](#input\_repository\_location) | The name of the location this repository is located in | `string` | n/a | yes |
| <a name="input_repository_project_id"></a> [repository\_project\_id](#input\_repository\_project\_id) | The ID of the project in which the repository belongs | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account to be created for GKE workload Identity (the part before @) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_runner_namespace"></a> [runner\_namespace](#output\_runner\_namespace) | n/a |

