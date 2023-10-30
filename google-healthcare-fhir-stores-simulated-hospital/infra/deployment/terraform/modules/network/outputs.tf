output "trust_network_name" {
  value = google_compute_network.trust.name
}

output "trust_northamerica_northeast1_subnetwork_name" {
  value = google_compute_subnetwork.trust_northamerica_northeast1.name
}