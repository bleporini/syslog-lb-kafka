#!/usr/bin/env bash

url=$(kubectl --namespace confluent get services/controlcenter-bootstrap-lb -o json|jq --raw-output '"http://" + .status.loadBalancer.ingress[0].ip')

open $url
