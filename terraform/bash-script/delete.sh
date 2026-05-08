#!/bin/bash

#connect to eks cluster 
aws eks update-kubeconfig --region eu-west-2  --name eks-cluster

# delete svc of traefik for alb to get destroyed
kubectl delete svc traefik -n traefik