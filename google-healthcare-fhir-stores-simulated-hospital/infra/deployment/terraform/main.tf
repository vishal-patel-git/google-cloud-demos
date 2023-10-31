provider "google" {
  project               = var.project_id
  region                = "northamerica-northeast1"
  billing_project       = var.project_id
  user_project_override = true
}

provider "google-beta" {
  project               = var.project_id
  region                = "northamerica-northeast1"
  billing_project       = var.project_id
  user_project_override = true
}

provider "docker" {
  registry_auth {
    address  = "northamerica-northeast1-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

data "google_client_config" "default" {
}

module "enable_apis" {
  source = "./modules/enable_apis"
}

module "kms" {
  source = "./modules/kms"

  depends_on = [
    module.enable_apis
  ]
}

module "iam" {
  source = "./modules/iam"

  default_confidential_crypto_key_id = module.kms.default_confidential_crypto_key_id
}

module "network" {
  source = "./modules/network"

  company_name = var.company_name
  environment  = var.environment
}

module "healthcare" {
  source = "./modules/healthcare"
}

module "simulated_hospital" {
  source = "./modules/simulated_hospital"

  default_confidential_crypto_key_id            = module.kms.default_confidential_crypto_key_id
  trust_network_name                            = module.network.trust_network_name
  trust_northamerica_northeast1_subnetwork_name = module.network.trust_northamerica_northeast1_subnetwork_name
  simulated_hospital_sa_email                   = module.iam.simulated_hospital_sa_email
  default_healthcare_dataset_id                 = module.healthcare.default_dataset_id
  default_healthcare_dataset_location           = module.healthcare.default_dataset_location
  default_fhir_store_id                         = module.healthcare.default_fhir_store_id
}