variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "location" {
  description = "location"
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
