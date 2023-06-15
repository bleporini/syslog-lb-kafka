#!/usr/bin/env bash 

#set -x 
docker run -ti --rm \
	-v $HOME/.config/gcloud:/root/.config/gcloud \
	-v $HOME/.kube:/root/.kube \
	google/cloud-sdk:latest gcloud "$@"
