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


/******************************************
Creation of firewall rules
*******************************************/
resource "google_compute_firewall" "create_subnet_firewall_rule" {
  project   = local.project_id 
  name      = "allow-intra-snet-ingress-to-any"
  network   = local.vpc_nm
  direction = "INGRESS"
  source_ranges = [local.subnet_cidr]
  allow {
    protocol = "all"
  }
  description        = "Creates firewall rule to allow ingress from within Spark subnet on all ports, all protocols"
  depends_on = [
    module.create_vpc_and_subnet
  ]
}
