# module "composer" {
#   source  = "terraform-google-modules/composer/google"
#   version = "~> 3.4"

#   project_id        = local.project_id
#   region            = local.location
#   zone              = "us-central1-a"
#   composer_env_name = "composer-env-test"
#   network           = local.vpc_nm
#   subnetwork        = local.subnet_nm
#   enable_private_endpoint = false
# }

resource "google_composer_environment" "composer_env" {
  name        = "your-composer-environment"
  location    = "us-central1"
  dag_bucket  = "your-gcs-bucket-for-dags"
  node_count  = 1
  node_config {
    zone          = "us-central1-a"
    machine_type  = "n1-standard-2"
    disk_size_gb  = 100
  }
}

resource "google_composer_environment_image_versions" "composer_image_versions" {
  location = "us-central1"
  image_version {
    image_version_id = "composer-2.0.0-airflow-2.1.2"
    supported_python_versions = ["3"]
  }
}


resource "google_composer_environment_iam_member" "iam_policy" {
  project     = local.project_id
  location    = local.location
  environment = google_composer_environment.my_environment.name
  role        = "Cloud Composer v2 API Service Agent Extension"
  member      = "177052975785-compute@developer.gserviceaccount.com"
}

resource "google_composer_environment_variable" "env_vars" {
  project     = local.project_id
  location    = local.location
  environment = google_composer_environment.my_environment.name

  variable {
    key   = "KEY1"
    value = "VALUE1"
  }

  variable {
    key   = "KEY2"
    value = "VALUE2"
  }
}

resource "google_composer_environment_iam_binding" "iam_binding" {
  project     = local.project_id
  location    = local.location
  environment = google_composer_environment.my_environment.name
  role        = "<desired-role>"

  members = [
    "<user-or-group-email-1>",
    "<user-or-group-email-2>",
  ]
}
