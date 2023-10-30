locals {
  simulated_hospital_sa_roles = [
    "roles/logging.logWriter"
  ]
}

resource "google_service_account" "simulated_hospital" {
  account_id   = "simulated-hospital-sa"
  display_name = "Simulated Hospital Service Account"
}

resource "google_project_iam_member" "simulated_hospital_sa" {
  for_each = toset(local.simulated_hospital_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.simulated_hospital.email}"
}