resource "google_artifact_registry_repository_iam_member" "vendors_management_api_sa_vendors_management_api_repository" {
  location   = google_artifact_registry_repository.vendors_management_api.location
  repository = google_artifact_registry_repository.vendors_management_api.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.vendors_management_api_sa_email}"
}

resource "google_secret_manager_secret_iam_member" "vendors_management_api_sa_vendors_management_api_user_password" {
  secret_id = google_secret_manager_secret.vendors_management_api_user_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.vendors_management_api_sa_email}"
}

resource "google_cloud_run_v2_service" "vendors_management_api" {
  name     = "vendors-management-api"
  location = "northamerica-northeast1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = var.vendors_management_api_sa_email
    encryption_key  = var.default_confidential_crypto_key_id

    containers {
      image = "${docker_registry_image.vendors_management_api.name}@${docker_registry_image.vendors_management_api.sha256_digest}"

      startup_probe {
        http_get {
          path = "/"
        }
      }

      liveness_probe {
        http_get {
          path = "/"
        }
      }

      env {
        name  = "LOG_LEVEL"
        value = "info"
      }
      env {
        name  = "NODE_ENV"
        value = "production"
      }
      env {
        name  = "PGHOST"
        value = google_sql_database_instance.vendors_management_api.private_ip_address
      }
      env {
        name  = "PGPORT"
        value = 5432
      }
      env {
        name  = "PGDATABASE"
        value = google_sql_database.vendors_management_api.name
      }
      env {
        name  = "PGUSERNAME"
        value = google_sql_user.vendors_management_api.name
      }
      env {
        name = "PGPASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.vendors_management_api_user_password.secret_id
            version = "latest"
          }
        }
      }
    }

    vpc_access {
      connector = var.trust_vpc_access_connector_northamerica_northeast1_id
      egress    = "ALL_TRAFFIC"
    }
  }

  depends_on = [
    google_artifact_registry_repository_iam_member.vendors_management_api_sa_vendors_management_api_repository,
    google_secret_manager_secret_iam_member.vendors_management_api_sa_vendors_management_api_user_password
  ]
}

resource "google_cloud_run_service_iam_member" "vendors_management_api_allow_unauthenticated" {
  location = google_cloud_run_v2_service.vendors_management_api.location
  service  = google_cloud_run_v2_service.vendors_management_api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}