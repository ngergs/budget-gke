resource "google_project_iam_custom_role" "kube_ip" {
  project     = var.project_id
  role_id     = "kubeip"
  title       = "kubeip"
  description = "See https://github.com/doitintl/kubeip/blob/master/roles.yaml"
  permissions = [
    "compute.addresses.list",
    "compute.instances.addAccessConfig",
    "compute.instances.deleteAccessConfig",
    "compute.instances.get",
    "compute.instances.list",
    "compute.projects.get",
    "container.clusters.get",
    "container.clusters.list",
    "resourcemanager.projects.get",
    "compute.networks.useExternalIp",
    "compute.subnetworks.useExternalIp",
    "compute.addresses.use"
  ]
}


resource "google_service_account" "kube_ip" {
  project      = var.project_id
  account_id   = "kubeip-service-account"
  display_name = "kubeip"
}

resource "google_project_iam_member" "firestore_owner_binding" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/${google_project_iam_custom_role.kube_ip.role_id}"
  member  = "serviceAccount:${google_service_account.kube_ip.email}"
}

resource "google_service_account_key" "kube_ip" {
  service_account_id = google_service_account.kube_ip.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
