variable "domain_names" {
  type        = list(string)
  description = "Domains for which a managed SSL certificate will be valid."
}

variable "google_compute_global_address_id" {
  type        = string
  description = "The Global HTTP Load Balancer IP address ID."
}

variable "api_cloud_run_services_names" {
  type = object({
    northamerica-northeast1 = object({
      name = string
    })
    northamerica-northeast2 = object({
      name = string
    })
  })

  description = "The API Cloud Run services names."
}