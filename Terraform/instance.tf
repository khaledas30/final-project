resource "google_compute_instance" "instance-terraform" {
  name         = "instance-terraform"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"
  service_account {
    email = google_service_account.service_account.email
    scopes = [ "cloud-platform" ]
  }
  boot_disk {
    initialize_params {
     image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.management-subnet.id

    
  } 
}