locals {
  default_service_directory  = "${path.module}/../../../../../default-service"
  default_service_repository = "${google_artifact_registry_repository.default_service.location}-docker.pkg.dev/${google_artifact_registry_repository.default_service.project}/${google_artifact_registry_repository.default_service.name}"
  default_service_image      = "${local.default_service_repository}/default-service"
}

resource "google_artifact_registry_repository" "default_service" {
  location      = "northamerica-northeast1"
  repository_id = "default-service-docker-repo"
  format        = "DOCKER"
  kms_key_name  = var.default_confidential_crypto_key_id
}

resource "docker_image" "default_service" {
  name = local.default_service_image
  build {
    context = local.default_service_directory
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(local.default_service_directory, "**") : filesha1("${local.default_service_directory}/${f}")]))
  }
}

resource "docker_registry_image" "default_service" {
  name = docker_image.default_service.name

  triggers = {
    docker_image_repo_digest = docker_image.default_service.repo_digest
  }
}