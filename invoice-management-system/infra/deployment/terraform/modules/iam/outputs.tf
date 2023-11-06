output "default_service_sa_email" {
  value = google_service_account.default_service.email
}

output "vendors_service_sa_email" {
  value = google_service_account.vendors_service.email
}