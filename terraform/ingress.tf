variable "gke_ingress_machine_type" {
  default     = "e2-medium"
  description = "machine typoe for the general node pool instances"
}

resource "google_compute_address" "ingress" {
  project = var.project_id
  region  = var.region
  name    = "ingress-adress"
  labels = {
    kubeip = google_container_cluster.primary.name
  }
}

resource "google_container_node_pool" "ingress_nodes" {
  project        = var.project_id
  name           = "${google_container_cluster.primary.name}-ingress-node-pool"
  location       = var.location
  node_locations = [var.location]
  cluster        = google_container_cluster.primary.name

  node_count = 1

  node_config {
    service_account = google_service_account.k8s.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    preemptible  = true
    machine_type = var.gke_ingress_machine_type
    disk_size_gb = 10
    tags         = ["gke-node", "ingress", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = true
    }
    image_type = "COS_CONTAINERD"
    shielded_instance_config {
      enable_secure_boot = true
    }
  }
}

resource "google_compute_firewall" "ingress" {
  project = var.project_id
  name    = "ingress"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags   = ["ingress"]
  source_ranges = ["0.0.0.0/0"]
}
