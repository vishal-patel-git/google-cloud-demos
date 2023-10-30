variable "company_name" {
  default     = "gcloudrecipes"
  description = "Company name."
}

variable "environment" {
  default     = "dev"
  description = "Deployment environment."
}

variable "project_id" {
  type        = string
  description = "Google Cloud Project ID."
}