resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "vendors_management_api" {
  name             = "vendors-management-api-${random_id.db_name_suffix.hex}"
  region           = "northamerica-northeast1"
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.trust.id
      enable_private_path_for_google_cloud_services = true
    }
  }

  encryption_key_name = var.default_confidential_crypto_key_id

  timeouts {
    create = "60m"
  }
}

resource "google_sql_database" "vendors_management_api" {
  name     = "vendors-management-api"
  instance = google_sql_database_instance.vendors_management_api.name
}

resource "random_password" "vendors_management_api_user_password" {
  keepers = {
    name = google_sql_database_instance.vendors_management_api.name
  }
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  length      = 32
  special     = false
}

resource "google_sql_user" "vendors_management_api" {
  name     = "vendors-management-api"
  password = random_password.vendors_management_api_user_password.result
  instance = google_sql_database_instance.vendors_management_api.name
}

resource "google_secret_manager_secret" "vendors_management_api_user_password" {
  secret_id = "vendors-management-api-user-password"

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"

        customer_managed_encryption {
          kms_key_name = var.default_confidential_crypto_key_id
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "vendors_management_api_user_password" {
  secret      = google_secret_manager_secret.vendors_management_api_user_password.id
  secret_data = google_sql_user.vendors_management_api.password
}