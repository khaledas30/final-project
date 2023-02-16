resource "google_container_cluster" "my-private-cluster" {
  name     = "cluster-terraform"
  location = "europe-west1-b"
   
  remove_default_node_pool = true
  initial_node_count       = 1
  network = google_compute_network.vpc_network.id
  subnetwork               = google_compute_subnetwork.restricted-subnet.id
  
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.1.0/24"
      display_name = "managment-cidr-range"
    }
  }
    
  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "khaled-ashraf.svc.id.goog"
  }
  ip_allocation_policy {
    
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  node_config {
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "nodepool" {
  name       = "nodepool"
  location   = "europe-west1-b"
  cluster    = google_container_cluster.my-private-cluster.id
  node_count = 1
   management {
    auto_repair  = true
    auto_upgrade = true
      }

  node_config {
    machine_type = "e2-medium"
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}