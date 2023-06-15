provider "google" {
  project = var.gcp_project
  region  = var.region
  zone    = var.region
}


resource "random_id" "id" {
  byte_length = 4
}


resource "google_container_cluster" "primary" {
  name               = "syslog-lb"
  initial_node_count = 6
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      owner = var.owner
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}
