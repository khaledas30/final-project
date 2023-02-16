provider "google" {
  credentials = file("/home/joe/Downloads/credential-finaltask.json")
  project     = "khaled-ashraf"
  region        = "europe-west1"
}
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}
resource "google_compute_network" "vpc_network" {
  project                 = "khaled-ashraf"
  name                    = "vpc-terraform"
  routing_mode                    = "REGIONAL"

  auto_create_subnetworks = false
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}
   