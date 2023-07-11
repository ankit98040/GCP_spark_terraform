resource "google_project_iam_member" "this" {
  project = var.project_id
  role    = "roles/composer.ServiceAgentV2Ext"
  member  = "serviceAccount:${google_service_account.this.email}"
}
