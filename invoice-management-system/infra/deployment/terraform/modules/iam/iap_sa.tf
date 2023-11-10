resource "google_project_service_identity" "iap_sa" {
  provider = google-beta

  project = data.google_project.project.project_id
  service = "iap.googleapis.com"
}