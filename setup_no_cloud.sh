#!/usr/bin/env bash

./terraform.sh init
./create_k8s.sh 

kubectl create secret generic control-center-user --from-file=basic.txt=creds-control-center-users.txt

kubectl apply -f cp-no-cloud.yml
