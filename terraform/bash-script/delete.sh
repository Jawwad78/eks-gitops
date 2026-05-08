#!/bin/bash

#connect to eks cluster 
aws eks update-kubeconfig --region eu-west-2  --name eks-cluster

# delete svc of traefik for nlb to get destroyed
kubectl delete svc traefik -n traefik