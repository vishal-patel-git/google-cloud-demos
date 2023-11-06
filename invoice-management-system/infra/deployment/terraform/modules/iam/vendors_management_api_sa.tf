locals {
  vendors_service_sa_roles = [
    "roles/logging.logWriter"
  ]
}

resource "google_service_account" "vendors_service" {
  account_id   = "vendors-service-sa"
  display_name = "Vendors Service Service Account"
}

resource "google_project_iam_member" "vendors_service_sa" {
  for_each = toset(local.vendors_service_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.vendors_service.email}"
}