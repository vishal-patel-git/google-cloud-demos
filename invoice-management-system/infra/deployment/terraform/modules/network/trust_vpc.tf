resource "google_compute_network" "trust" {
  # See https://cloud.google.com/architecture/best-practices-trust-design#naming
  name                    = "${var.company_name}-${var.environment}-trust-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "trust_proxy_only_northamerica_northeast1" {
  name          = "${var.company_name}-${var.environment}-trust-proxy-na-ne1"
  ip_cidr_range = "10.162.0.0/23"
  region        = "northamerica-northeast1"
  network       = google_compute_network.trust.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

resource "google_compute_subnetwork" "trust_vpc_access_connector_northamerica_northeast1" {
  name          = "${var.company_name}-${var.environment}-trust-vpc-conn-na-ne1"
  ip_cidr_range = "10.162.2.0/28"
  region        = "northamerica-northeast1"
  network       = google_compute_network.trust.id
}

resource "google_vpc_access_connector" "trust_northamerica_northeast1" {
  name = "vpc-conn-na-ne1"
  subnet {
    name = google_compute_subnetwork.trust_vpc_access_connector_northamerica_northeast1.name
  }
}

resource "google_compute_global_address" "trust_private_ip_address" {
  name          = "vpc-peering-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.trust.id
}

resource "google_service_networking_connection" "trust_private_vpc_connection" {
  network                 = google_compute_network.trust.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.trust_private_ip_address.name]
}