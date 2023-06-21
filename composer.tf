module "composer" {
  source  = "terraform-google-modules/composer/google"
  version = "~> 3.4"

  project_id        = local.project_id
  region            = local.location
  zone              = "us-central1-a"
  composer_env_name = "composer-env-test"
  network           = local.vpc_nm
  subnetwork        = local.subnet_nm
  enable_private_endpoint = false
}