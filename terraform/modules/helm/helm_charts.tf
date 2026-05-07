resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.20.2"

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },

  ]

  #insert my values file
  values = [
    file("${path.module}/certmanager-values.yaml")
  ]

  depends_on = [ helm_release.app ]
}


resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik"
  create_namespace = true
  version          = "39.0.9"
  
  values = [
    file("${path.module}/traefik-values.yaml")
  ]

  depends_on = [ helm_release.app ]
}


resource "helm_release" "app" {
  name  = "deploy"
  chart = "./modules/kubernetes/app"

  depends_on = [helm_release.argocd]
}

resource "helm_release" "external-dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true
  version          = "v1.19.0"

  values = [
    file("${path.module}/externaldns-values.yaml")
  ]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "v84.0.0"

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "v7.7.0"
 
}