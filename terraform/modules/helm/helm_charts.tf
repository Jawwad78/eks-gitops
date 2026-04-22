resource "helm_release" "cert-manager" {
  name = "cert-manager"

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

  depends_on = [var.node_group_name]
}

resource "helm_release" "traefik" {
  name = "traefik"

  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik"
  create_namespace = true


  values = [
    file("${path.module}/traefik-values.yaml")
  ]

   depends_on = [var.node_group_name]
}

resource "helm_release" "app" {
  name      = "deploy"
  chart     = "./modules/kubernetes/app"

   depends_on = [var.node_group_name]
}

resource "helm_release" "external-dns" {
  name = "external-dns"

  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  

  values = [
    file("${path.module}/externaldns-values.yaml")
  ]

   depends_on = [var.node_group_name]
}