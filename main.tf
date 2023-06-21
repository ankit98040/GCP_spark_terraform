locals {
lab_prefix                  = "dll"
project_id                  = "${var.project_id}"
location                    = "${var.location}"
umsa                        = "${local.lab_prefix}-lab-sa"
umsa_fqn                    = "${local.umsa}@${local.project_id}.iam.gserviceaccount.com"
admin_upn_fqn               = "${var.gcp_account_name}"
vpc_nm                      = "${local.lab_prefix}-vpc"
subnet_nm                   = "spark-snet"
nat_nm                      = "${local.lab_prefix}-nat"
nat_router_nm               = "${local.lab_prefix}-nat-router"
subnet_cidr                 = "10.0.0.0/16"
psa_ip_length               = 16
}