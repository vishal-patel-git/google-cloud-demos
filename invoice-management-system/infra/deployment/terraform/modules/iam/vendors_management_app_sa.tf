locals {
  vendors_management_app_sa_roles = [
    "roles/logging.logWriter"
  ]
}

resource "google_service_account" "vendors_management_app" {
  account_id   = "vendors-management-app-sa"
  display_name = "Vendors Management App Service Account"
}

resource "google_project_iam_member" "vendors_management_app_sa" {
  for_each = toset(local.vendors_management_app_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.vendors_management_app.email}"
}