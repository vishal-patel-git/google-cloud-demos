resource "google_apikeys_key" "google_maps_services" {
  name         = "vendors-management-api-google-maps-services-api-key"
  display_name = "Vendors Management API Google Maps Services API Key"

  restrictions {
    api_targets {
      service = "places-backend.googleapis.com"
    }
  }
}

resource "google_secret_manager_secret" "google_maps_api_key" {
  secret_id = "vendors-management-api-google-maps-services-api-key"

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

resource "google_secret_manager_secret_version" "google_maps_api_key" {
  secret      = google_secret_manager_secret.google_maps_api_key.id
  secret_data = google_apikeys_key.google_maps_services.key_string
}