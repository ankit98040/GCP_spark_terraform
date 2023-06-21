locals {
lab_prefix                  = "dll"
project_id                  = "${var.project_id}"
location                    = "${var.location}"
umsa                        = "${local.lab_prefix}-lab-sa"
umsa_fqn                    = "${local.umsa}@${local.project_id}.iam.gserviceaccount.com"
admin_upn_fqn               = "${var.gcp_account_name}"
}