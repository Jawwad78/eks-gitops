# EKS Cloud Native DevOps Project

## Project Overview

This project is an end to end cloud native deployment of an application on AWS using Amazon EKS.

The goal of the project was to combine modern Kubernetes and DevOps tools together in one production style environment, covering infrastructure automation, GitOps, ingress routing, TLS, monitoring, observability, and secure CI/CD practices.

The application is deployed into EKS and managed using Terraform, Helm, Argo CD, Prometheus, Grafana, cert manager, and ExternalDNS.

## Infrastructure Diagram

<img width="1684" height="1481" alt="Image" src="https://github.com/user-attachments/assets/8053da44-12bb-4640-a9e2-2341bed1c55f" />

## Architecture

The infrastructure is provisioned using Terraform with remote state stored in S3 with native S3 locking.

Main components used:

- Amazon EKS for Kubernetes orchestration
- Traefik Ingress Controller fronted by an AWS NLB
- cert manager with Let’s Encrypt for HTTPS certificates
- ExternalDNS with Route53 for automated DNS management
- Argo CD for GitOps deployments
- Prometheus and Grafana for monitoring and observability
- Alertmanager for email based alerting
- GitHub Actions for CI/CD automation and security scanning

## GitOps Flow

GitHub Actions is used to automate Terraform workflows and security scanning using Checkov and Trivy.

Kubernetes manifests are stored in Git and managed through Argo CD.

Argo CD continuously compares the desired state stored in Git with the live EKS cluster state and syncs any differences through the Kubernetes API server.

Traefik, cert manager, Let's Encrypt, and ExternalDNS work together to automatically provide HTTPS access and DNS routing for the application.

## Security & Best Practices

The project includes several production style security practices:

- OIDC authentication from GitHub Actions to AWS without hardcoded credentials
- IRSA for secure AWS access from Kubernetes workloads
- Multi stage Docker builds to reduce final image size
- Non root container user for reduced container privileges
- Prometheus kept internal while Grafana is protected with authentication, access, and control
- DRY Terraform and Helm configuration with reduced hardcoding

## Monitoring & Observability

Prometheus is used to scrape Kubernetes cluster metrics while Grafana visualises dashboards for cluster health, pod usage, and resource monitoring.

Alertmanager is configured with email alerts to improve awareness when issues occur inside the cluster.

Prometheus data is stored persistently using EBS volumes through the gp2 StorageClass.

## Demonstration

EKS Cluster

Argo CD

<img width="1918" height="1030" alt="Image" src="https://github.com/user-attachments/assets/2a05201c-d8e2-4307-aa62-2810dbbb1a05" />

Application UI

<img width="1918" height="1022" alt="Image" src="https://github.com/user-attachments/assets/b0284433-030c-4c7c-9eba-d0cfcd0d75dc" />

Grafana Dashboards

<img width="1915" height="1032" alt="Image" src="https://github.com/user-attachments/assets/4ccb83c9-3a8e-4f84-866f-c8d555e80372" />

## Tools & Technologies

- Argo CD
- Traefik
- Prometheus
- Grafana
- Alertmanager
- Route53
- ExternalDNS
- cert manager
- Checkov
- Trivy
- Helm

## Why This Project Matters

This project demonstrates how modern DevOps and Kubernetes tools can work together in a production style AWS environment.

It showcases skills in:

- Infrastructure as Code
- Kubernetes operations
- GitOps workflows
- Monitoring and observability
- Secure CI/CD pipelines
- Cloud native deployment practices