variable "default_confidential_crypto_key_id" {
  type        = string
  description = "Default northamerica-northeast1 confidential KMS crypto key ID."
}

variable "trust_network_name" {
  type        = string
  description = "Trust VPC network name."
}

variable "trust_vpc_access_connector_northamerica_northeast1_id" {
  type        = string
  description = "Trust northamerica-northeast1 VPC Access Connector ID."
}

variable "vendors_management_api_sa_email" {
  type        = string
  description = "Vendors Management API Service Account email."
}