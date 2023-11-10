resource "google_iap_brand" "vendors_management_app" {
  support_email     = var.vendors_management_app_support_email
  application_title = "Invoice Management System - Vendors Management App"
}

resource "google_iap_client" "vendors_management_app" {
  display_name = "Vendors Management App Client"
  brand        = google_iap_brand.vendors_management_app.name
}