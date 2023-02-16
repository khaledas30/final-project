resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_project_iam_member" "vm_sa" {
  project = "khaled-ashraf"
  role    ="roles/container.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}