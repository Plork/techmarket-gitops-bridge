module "cluster" {
  source = "./modules/cluster"

  cluster_name    = local.cluster.name
  cluster_version = local.cluster.version
}

module "cluster_addons" {
  source = "./modules/cluster-addons"

  addons         = local.cluster.addons
  argocd         = local.cluster.argocd
  cloud_provider = "minikube"
  environment    = var.environment
  gitops         = local.cluster.gitops
  domain_name    = local.domain_name

  cluster = {
    name                   = module.cluster.name
    version                = module.cluster.version
    endpoint               = module.cluster.endpoint
    client_certificate     = module.cluster.client_certificate
    client_key             = module.cluster.client_key
    cluster_ca_certificate = module.cluster.cluster_ca_certificate
  }
}
