locals {
  default_service_sa_roles = [
    "roles/logging.logWriter"
  ]
}

resource "google_service_account" "default_service" {
  account_id   = "default-service-sa"
  display_name = "Default Service Service Account"
}

resource "google_project_iam_member" "default_service_sa" {
  for_each = toset(local.default_service_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.default_service.email}"
}