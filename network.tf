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
