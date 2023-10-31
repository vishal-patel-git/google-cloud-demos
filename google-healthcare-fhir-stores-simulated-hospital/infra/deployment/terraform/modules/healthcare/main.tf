resource "google_healthcare_dataset" "default" {
  name     = "default-dataset"
  location = "northamerica-northeast1"
}

resource "google_healthcare_fhir_store" "default" {
  name    = "default-fhir-store"
  dataset = google_healthcare_dataset.default.id
  version = "R4"
}
