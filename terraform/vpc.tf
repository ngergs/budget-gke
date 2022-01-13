# VPC
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  project       = var.project_id
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/8"
  private_ip_google_access = "true"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "192.168.64.0/18"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "192.168.128.0/18"
  }
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.project_id}-router"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "${var.project_id}-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
