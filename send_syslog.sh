#!/usr/bin/env bash

lb_ip=$(kubectl get services/syslog-service -o json|jq --raw-output '.status.loadBalancer.ingress[0].ip')

echo "<34>1 2003-10-11T22:14:15.003Z mymachine.example.com su - ID47 - Your refrigerator is running" | nc -v -w 0 $lb_ip 5454
echo "<34>1 2003-10-11T22:14:15.003Z mymachine.example.com su - ID47 - Your refrigerator is running" | nc -v -w 0 $lb_ip 5454
