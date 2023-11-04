output "load_balancer_ip_address" {
  value = google_compute_address.load_balancer.address
}

output "load_balancer_ssl_certificate_name" {
  value = module.load_balancer.ssl_certificate_name
}

output "terraform_tfstate_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "terraform_tfvars_secret" {
  value = google_secret_manager_secret.terraform_tfvars.name
}