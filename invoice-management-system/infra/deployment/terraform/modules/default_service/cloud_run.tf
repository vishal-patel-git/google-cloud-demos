resource "google_artifact_registry_repository_iam_member" "default_service_sa_default_service_repository" {
  location   = google_artifact_registry_repository.default_service.location
  repository = google_artifact_registry_repository.default_service.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.default_service_sa_email}"
}

resource "google_cloud_run_v2_service" "default_service" {
  name     = "default-service"
  location = "northamerica-northeast1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = var.default_service_sa_email
    encryption_key  = var.default_confidential_crypto_key_id

    containers {
      image = "${docker_registry_image.default_service.name}@${docker_registry_image.default_service.sha256_digest}"

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
    }
  }

  depends_on = [
    google_artifact_registry_repository_iam_member.default_service_sa_default_service_repository,
  ]
}

resource "google_cloud_run_service_iam_member" "default_service_allow_unauthenticated" {
  location = google_cloud_run_v2_service.default_service.location
  service  = google_cloud_run_v2_service.default_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}