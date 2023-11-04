output "default_service_sa_email" {
  value = google_service_account.default_service.email
}

output "vendors_management_api_sa_email" {
  value = google_service_account.vendors_management_api.email
}