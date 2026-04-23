terraform {
  required_providers {
    ucloud    = {
      source  = "hashicorp/google"
      version = ">=6.11.1"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_svc_key)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}
