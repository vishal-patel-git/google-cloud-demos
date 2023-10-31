data "google_project" "project" {
}

data "google_compute_zones" "available" {
}

module "gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = "eu.gcr.io/simhospital-images/simhospital:latest"
    command = [
      "health/simulator",
      "--resource_output=cloud",
      "--cloud_project_id=${data.google_project.project.project_id}",
      "--cloud_location=${var.default_healthcare_dataset_location}",
      "--cloud_dataset=${var.default_healthcare_dataset_id}",
      "--cloud_datastore=${var.default_fhir_store_id}",
      "--pathways_per_hour=240"
    ]
  }

  restart_policy = "Always"
}

resource "google_healthcare_dataset_iam_member" "default_dataset_simulated_hospital_sa" {
  dataset_id = var.default_healthcare_dataset_id
  role       = "roles/editor"
  member     = "serviceAccount:${var.simulated_hospital_sa_email}"
}

resource "google_healthcare_fhir_store_iam_member" "default_fhir_store_simulated_hospital_sa" {
  fhir_store_id = var.default_fhir_store_id
  role          = "roles/editor"
  member        = "serviceAccount:${var.simulated_hospital_sa_email}"
}


module "vm_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 10.1"

  name_prefix  = "simulated-hospital"
  region       = "northamerica-northeast1"
  machine_type = "f1-micro"
  service_account = {
    email = var.simulated_hospital_sa_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  source_image_family  = "cos-stable"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce_container.source_image))[0]
  network              = var.trust_network_name
  subnetwork           = var.trust_northamerica_northeast1_subnetwork_name
  metadata = {
    "gce-container-declaration" = module.gce_container.metadata_value
  }
  labels = {
    "container-vm" = module.gce_container.vm_container_label
  }
}

resource "google_compute_instance_from_template" "vm" {
  name = "simulated-hospital"
  zone = data.google_compute_zones.available.names[0]

  source_instance_template = module.vm_template.self_link

  depends_on = [
    google_healthcare_dataset_iam_member.default_dataset_simulated_hospital_sa,
    google_healthcare_fhir_store_iam_member.default_fhir_store_simulated_hospital_sa
  ]
}