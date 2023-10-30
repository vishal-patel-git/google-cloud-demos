output "terraform_tfstate_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "terraform_tfvars_secret" {
  value = google_secret_manager_secret.terraform_tfvars.name
}