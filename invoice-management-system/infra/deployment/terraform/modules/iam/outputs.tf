output "vendors_service_sa_email" {
  value = google_service_account.vendors_service.email
}

output "vendors_management_app_sa_email" {
  value = google_service_account.vendors_management_app.email
}