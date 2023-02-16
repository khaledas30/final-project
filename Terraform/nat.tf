resource "google_compute_address" "address" {
  name   = "nat-address"
  region = google_compute_subnetwork.management-subnet.region
}
resource "google_compute_address" "nat-jen" {
  name   = "nat-jenkins"
  region = google_compute_subnetwork.restricted-subnet.region 
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router-terraform.name
  region                             = google_compute_router.router-terraform.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.address.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.management-subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  
}
resource "google_compute_router_nat" "nat-jke" {
  name                               = "nat-jen"
  router                             = google_compute_router.router-jenkins.name
  region                             = google_compute_router.router-jenkins.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat-jen.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.restricted-subnet.id 
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  
}

