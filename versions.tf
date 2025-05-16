terraform {
  required_version = ">= 1.6.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50, < 5.11.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.48, < 5.12.0"
    }
  }
}