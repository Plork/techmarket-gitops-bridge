provider "kind" {}

provider "kubernetes" {
  config_path    = module.cluster.kubeconfig
  config_context = module.cluster.name
}
