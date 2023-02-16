resource "google_compute_firewall" "allow_ssh" {
  project = "khaled-ashraf"
  name    = "allow-ssh"
  network =google_compute_network.vpc_network.id
  direction     = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  #iap range
  source_ranges = ["35.235.240.0/20"]
}
