resource "google_compute_network" "trust" {
  # See https://cloud.google.com/architecture/best-practices-vpc-design#naming
  name                    = "${var.company_name}-${var.environment}-vpc-trust"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "trust_northamerica_northeast1" {
  name          = "${var.company_name}-${var.environment}-trust-na-ne-1"
  ip_cidr_range = "10.162.0.0/20"
  region        = "northamerica-northeast1"
  network       = google_compute_network.trust.name
}

# https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
resource "google_compute_firewall" "allow_ingress_from_iap" {
  name     = "allow-ingress-from-iap"
  network  = google_compute_network.trust.name
  priority = 65534

  source_ranges = [
    "35.235.240.0/20"
  ]

  allow {
    protocol = "TCP"
    ports = [
      "22",
      "3389"
    ]
  }
}

resource "google_compute_router" "trust_northamerica_northeast1_router" {
  name    = "${var.company_name}-${var.environment}-trust-na-ne-1-router"
  region  = google_compute_subnetwork.trust_northamerica_northeast1.region
  network = google_compute_network.trust.id
}

resource "google_compute_router_nat" "trust_northamerica_northeast1_nat" {
  name                               = "${var.company_name}-${var.environment}-trust-na-ne-1-nat"
  router                             = google_compute_router.trust_northamerica_northeast1_router.name
  region                             = google_compute_router.trust_northamerica_northeast1_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.trust_northamerica_northeast1.name
    source_ip_ranges_to_nat = [
      "PRIMARY_IP_RANGE"
    ]
  }
}