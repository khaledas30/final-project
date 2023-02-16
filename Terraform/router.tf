resource "google_compute_router" "router-terraform" {
  name    = "my-router"
  region  = google_compute_subnetwork.management-subnet.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}  
resource "google_compute_router" "router-jenkins" {
  name    = "router-jke"
  region  = google_compute_subnetwork.restricted-subnet.region 
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}  