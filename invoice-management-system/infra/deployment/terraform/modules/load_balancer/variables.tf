variable "default_confidential_crypto_key_id" {
  type        = string
  description = "Default northamerica-northeast1 confidential KMS crypto key ID."
}

variable "trust_network_name" {
  type        = string
  description = "Trust VPC network name."
}

variable "vendors_management_app_cloud_run_service_name" {
  type        = string
  description = "Vendors Management App Cloud Run service name."
}

variable "ssl_certificate" {
  type        = string
  description = "SSL certificate in PEM format."
}

variable "ssl_certificate_private_key" {
  type        = string
  description = "SSL certificate write-only private key in PEM format."
}

variable "google_compute_address_id" {
  type        = string
  description = "Regional HTTP Load Balancer IP address ID."
}