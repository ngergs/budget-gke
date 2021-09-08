data "google_project" "project" {
  project_id = var.project_id
}
data "google_client_config" "k8s" {}

variable "gke_min_node_count" {
  default     = 1
  description = "minimal number of gke nodes"
}

variable "gke_max_node_count" {
  default     = 2
  description = "maximal number of gke nodes"
}

variable "gke_general_machine_type" {
  default     = "e2-medium"
  description = "machine typoe for the general node pool instances"
}
variable "gke_release_channel" {
  default     = "REGULAR"
  description = "GKE release channel, one of UNSPECIFIED, RAPID, REGULAR, STABLE"
}
variable "gke_admin_cidr_block" {
  default     = ""
  description = "Admin cidr_block for access to the kubernetes master"
}
variable "gke_key_ring_name" {
  default     = "k8s"
  description = "Name for the k8s key ring"
}
variable "gke_secrets_key_name" {
  default     = "k8s"
  description = "Name for the k8s secret key ring used for secrets encryption"
}

resource "google_service_account" "k8s" {
  project      = var.project_id
  account_id   = "${var.project_id}-k8s"
  display_name = "${var.project_id}-k8s"
}

resource "google_project_iam_member" "logging_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.k8s.email}"
}

resource "google_project_iam_member" "monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.k8s.email}"
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.k8s.email}"
}
resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = data.google_kms_crypto_key.k8s_secret_key.self_link
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

data "google_kms_key_ring" "k8s" {
  project  = var.project_id
  location = var.region
  name     = var.gke_key_ring_name
}
data "google_kms_crypto_key" "k8s_secret_key" {
  name     = var.gke_secrets_key_name
  key_ring = data.google_kms_key_ring.k8s.self_link
}

# GKE cluster
resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = "${var.project_id}-gke"
  location = var.location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  release_channel {
    channel = var.gke_release_channel
  }
  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.gke_admin_cidr_block
    }
  }
  enable_shielded_nodes = true
  database_encryption {
    state    = "ENCRYPTED"
    key_name = data.google_kms_crypto_key.k8s_secret_key.self_link
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  project        = var.project_id
  name           = "${google_container_cluster.primary.name}-node-pool"
  location       = var.location
  node_locations = [var.location]
  cluster        = google_container_cluster.primary.name

  autoscaling {
    min_node_count = var.gke_min_node_count
    max_node_count = var.gke_max_node_count
  }

  node_config {
    service_account = google_service_account.k8s.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    preemptible  = true
    machine_type = var.gke_general_machine_type
    disk_size_gb = 10
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = true
    }
    image_type = "COS_CONTAINERD"
    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}


provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.k8s.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}
