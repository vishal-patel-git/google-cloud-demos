output "default_dataset_id" {
  value = google_healthcare_dataset.default.id
}

output "default_dataset_location" {
  value = google_healthcare_dataset.default.location
}

output "default_fhir_store_id" {
  value = google_healthcare_fhir_store.default.id
}