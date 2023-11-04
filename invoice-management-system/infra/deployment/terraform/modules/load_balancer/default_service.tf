resource "google_compute_region_network_endpoint_group" "default_service" {
  name                  = "${var.default_service_cloud_run_service_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "northamerica-northeast1"
  cloud_run {
    service = var.default_service_cloud_run_service_name
  }
}

resource "google_compute_region_backend_service" "default_service" {
  name                  = "${var.default_service_cloud_run_service_name}-backend"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_network_endpoint_group.default_service.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}