# provider "google-beta" {
#   project = var.project_id
#   region  = "us-central1"
# }

# resource "google_project_service" "composer_api" {
#   provider = google-beta
#   project = var.project_id
#   service = "composer.googleapis.com"
#   // Disabling Cloud Composer API might irreversibly break all other
#   // environments in your project.
#   disable_on_destroy = false
# }

# resource "google_service_account" "custom_service_account" {
#   provider = google-beta
#   account_id   = var.project_id
#   display_name = "Example Custom Service Account"
# }

# resource "google_project_iam_member" "custom_service_account" {
#   provider = google-beta
#   project  = var.project_id
#   member   = format("serviceAccount:%s", google_service_account.custom_service_account.email)
#   // Role for Public IP environments
#   role     = "roles/composer.worker"
# }

# resource "google_project_iam_member" "custom_service_account2" {
#   provider = google-beta
#   project  = var.project_id
#   member   = format("serviceAccount:%s", google_service_account.custom_service_account.email)
#   // Role for Public IP environments
#   role     = "roles/composer.ServiceAgentV2Ext"
# }

# resource "google_composer_environment" "example_environment" {
#   provider = google-beta
#   name = "example-environment"

#   config {

#     node_config {
#       service_account = google_service_account.custom_service_account.email
#     }

#   }
# }
module "umsa_creation" {
  source     = "terraform-google-modules/service-accounts/google"
  project_id = var.project_id
  names      = ["${var.umsa}"]
  display_name = "User Managed Service Account"
  description  = "User Managed Service Account"
  project_roles = [
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/storage.objectAdmin",
    "roles/storage.admin",
    "roles/metastore.admin",
    "roles/metastore.editor",
    "roles/dataproc.editor",
    "roles/dataproc.admin",
    "roles/dataproc.worker",
    "roles/bigquery.dataEditor",
    "roles/composer.admin",
    "roles/iam.serviceAccountCreator",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceaccountuser",
    "roles/bigquery.admin",
    "roles/artifactregistry.writer",
    "roles/logging.logWriter",
    "roles/cloudbuild.builds.editor",
    "roles/aiplatform.admin",
    "roles/aiplatform.viewer",
    "roles/aiplatform.user",
    "roles/viewer"
  ]
}

/******************************************
Creation of a VPC & Subnet
******************************************/
module "create_vpc_and_subnet" {
  source                                 = "terraform-google-modules/network/google"
  project_id                             = local.project_id
  network_name                           = local.vpc_nm
  routing_mode                           = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${local.subnet_nm}"
      subnet_ip             = "${local.subnet_cidr}"
      subnet_region         = "${local.location}"
      subnet_range          = local.subnet_cidr
      subnet_private_access = true
    }
  ]
}


module "composer_env" {
  source = "terraform-google-modules/composer/google//modules/create_environment_v2"
  project_id                       = var.project_id
  network_project_id               = var.project_id
  composer_env_name                = var.composer_env_name
  region                           = var.region
  composer_service_account         = module.umsa.email
  network                          = local.vpc_nm
  subnetwork                       = local.subnet_nm
#   pod_ip_allocation_range_name     = var.pod_ip_allocation_range_name
#   service_ip_allocation_range_name = var.service_ip_allocation_range_name
  grant_sa_agent_permission        = true
  use_private_environment          = true
  enable_private_endpoint          = true
  environment_size                 = "ENVIRONMENT_SIZE_SMALL"
  scheduler = {
    cpu        = 1
    memory_gb  = 1.875
    storage_gb = 1
    count      = 1
  }
  web_server = {
    cpu        = 1
    memory_gb  = 2
    storage_gb = 10
  }
  worker = {
    cpu        =1
    memory_gb  = 2
    storage_gb = 1
    min_count  = 1
    max_count  = 6
  }
  depends_on = [
    module.umsa,
    # module.umsa_role_grants
  ]
}