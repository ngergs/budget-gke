terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=4.0.0, <5.0.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">=4.0.0, <5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.6.1, <3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.1.0, <3.0.0"
    }
  }
  required_version = "> 1.0"
}
