terraform {
	required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }

    confluent = {
      source  = "confluentinc/confluent"
      version = "1.43.0"
    }
	}


  required_version = ">= 0.14"
}
