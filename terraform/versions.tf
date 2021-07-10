terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = ">3.72.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.1.0"
    }
  }
  required_version = "> 1.0"
}
