#!/usr/bin/env bash

./terraform.sh init
./terraform.sh apply 
./create_k8s.sh

kubectl create secret generic cloud-plain --from-file=plain.txt=api_key.txt --namespace confluent

kubectl create secret generic control-center-user --from-file=basic.txt=creds-control-center-users.txt

kubectl create secret generic kafka-client-config-secure --from-file=kafka.properties  --namespace confluent

kubectl apply -f cp.yml
