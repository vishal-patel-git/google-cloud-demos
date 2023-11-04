locals {
  vendors_management_api_directory  = "${path.module}/../../../../../vendors-management-api"
  vendors_management_api_repository = "${google_artifact_registry_repository.vendors_management_api.location}-docker.pkg.dev/${google_artifact_registry_repository.vendors_management_api.project}/${google_artifact_registry_repository.vendors_management_api.name}"
  vendors_management_api_image      = "${local.vendors_management_api_repository}/vendors-management-api"
}

resource "google_artifact_registry_repository" "vendors_management_api" {
  location      = "northamerica-northeast1"
  repository_id = "vendors-management-api-docker-repo"
  format        = "DOCKER"
  kms_key_name  = var.default_confidential_crypto_key_id
}

resource "docker_image" "vendors_management_api" {
  name = local.vendors_management_api_image
  build {
    context = local.vendors_management_api_directory
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(local.vendors_management_api_directory, "**") : filesha1("${local.vendors_management_api_directory}/${f}")]))
  }
}

resource "docker_registry_image" "vendors_management_api" {
  name = docker_image.vendors_management_api.name

  triggers = {
    docker_image_repo_digest = docker_image.vendors_management_api.repo_digest
  }
}