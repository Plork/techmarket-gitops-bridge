module "argo_cd" {
  source = "./modules/argo-cd"

  addons       = local.addons
  apps         = local.argocd_apps
  cluster_name = var.cluster.name
  environment  = var.environment
  metadata     = local.addons_metadata
  url          = var.argocd.url
}
