data "google_compute_zones" "available" {
}

module "gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = "eu.gcr.io/simhospital-images/simhospital:latest"
    command = [
      "health/simulator"
    ]
  }

  restart_policy = "Always"
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
}