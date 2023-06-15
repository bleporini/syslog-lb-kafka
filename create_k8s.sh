#!/usr/bin/env bash

set -e

./terraform.sh apply -target=google_container_cluster.primary 

./gcloud.sh container clusters get-credentials $(./terraform.sh output -raw kubernetes_cluster_name) --region $(./terraform.sh output -raw kubernetes_cluster_location)

./install_cfk.sh
