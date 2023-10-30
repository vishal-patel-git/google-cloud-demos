variable "default_confidential_crypto_key_id" {
  type        = string
  description = "Default Confidential KMS crypto key ID."
}

variable "trust_network_name" {
  type        = string
  description = "The Trust VPC network name."
}

variable "trust_northamerica_northeast1_subnetwork_name" {
  type        = string
  description = "The Trust northamerica-northeast1 subnetwork name."
}

variable "simulated_hospital_sa_email" {
  type        = string
  description = "Simulated Hospital Service Account email."
}

