variable "default_confidential_crypto_key_id" {
  type        = string
  description = "Default northamerica-northeast1 confidential KMS crypto key ID."
}

variable "vendors_management_app_sa_email" {
  type        = string
  description = "Vendors Management App Service Account email."
}

variable "trust_vpc_access_connector_northamerica_northeast1_id" {
  type        = string
  description = "Trust northamerica-northeast1 VPC Access Connector ID."
}

variable "vendors_service_name" {
  type        = string
  description = "Vendors Service Cloud Run service name."
}