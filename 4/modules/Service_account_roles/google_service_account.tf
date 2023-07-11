resource "google_service_account" "this" {
  # xxx. Enable the IAM API.
  # link: https://console.cloud.google.com/marketplace/product/google/iam.googleapis.com?q=search&referrer=search&authuser=2&project=xxxxxxx
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
}


# resource "google_service_account" "this" {
#   account_id = var.account_id
#   display_name = "SA"
# }

# resource "google_project_iam_member" "firestore_owner_binding" {
#   project = var.project_id
#   role    = "roles/composer.ServiceAgentV2Ex"
#   member  = "serviceAccount:${google_service_account.this.email}"
# }