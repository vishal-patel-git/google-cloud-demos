output "trust_network_name" {
  value = google_compute_network.trust.name
}

output "trust_vpc_access_connector_northamerica_northeast1_id" {
  value = google_vpc_access_connector.trust_northamerica_northeast1.id
}