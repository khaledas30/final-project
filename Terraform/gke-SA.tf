resource "google_service_account" "gke_sa" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
  
}


resource "google_project_iam_member" "gke_role" {
  project = "khaled-ashraf"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_admin_role" {
  project = "khaled-ashraf"
  role               = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}