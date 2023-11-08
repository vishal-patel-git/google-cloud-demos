resource "google_compute_region_network_endpoint_group" "vendors_management_app_service" {
  name                  = "${var.vendors_management_app_cloud_run_service_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "northamerica-northeast1"
  cloud_run {
    service = var.vendors_management_app_cloud_run_service_name
  }
}

resource "google_compute_region_backend_service" "vendors_management_app_service" {
  name                  = "${var.vendors_management_app_cloud_run_service_name}-backend"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_network_endpoint_group.vendors_management_app_service.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}