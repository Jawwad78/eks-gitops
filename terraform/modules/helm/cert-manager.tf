# resource "helm_release" "cert-manager" {
#   name       = "cert-manager"

#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   namespace = "cert-manager"
#   create_namespace = true
#   version    = "v1.14.4"

#   set = [
#     {
#       name  = "installCRDs"
#       value = "true"
#     },
#     {
#       name  = "serviceAccount.name"
#       value = "cert-manager"
#     },
    
#   ]
#   depends_on = [ var.node_group_name ]
# }
