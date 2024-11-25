# Terraform relies on plugins called providers to interact with cloud providers. providers require configuration (like endpoint URLs or cloud regions) before they can be used.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=6.11.1"
    }
  }
}

