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

module "default_service" {
  source = "./modules/default_service"

  default_confidential_crypto_key_id = module.kms.default_confidential_crypto_key_id
  default_service_sa_email           = module.iam.default_service_sa_email
}

module "vendors_management_api" {
  source = "./modules/vendors_management_api"

  default_confidential_crypto_key_id                    = module.kms.default_confidential_crypto_key_id
  trust_network_name                                    = module.network.trust_network_name
  trust_vpc_access_connector_northamerica_northeast1_id = module.network.trust_vpc_access_connector_northamerica_northeast1_id
  vendors_management_api_sa_email                       = module.iam.vendors_management_api_sa_email
}

resource "google_compute_address" "load_balancer" {
  name         = "invoice-management-system-lb-address"
  network_tier = "STANDARD"
}

module "load_balancer" {
  source = "./modules/load_balancer"

  default_confidential_crypto_key_id            = module.kms.default_confidential_crypto_key_id
  trust_network_name                            = module.network.trust_network_name
  default_service_cloud_run_service_name        = module.default_service.default_service_cloud_run_service_name
  vendors_management_api_cloud_run_service_name = module.vendors_management_api.vendors_management_api_cloud_run_service_name
  ssl_certificate                               = var.ssl_certificate
  ssl_certificate_private_key                   = var.ssl_certificate_private_key
  google_compute_address_id                     = google_compute_address.load_balancer.id
}