provider "helm" {
  kubernetes = {
    host = var.cluster.endpoint

    client_certificate     = var.cluster.client_certificate
    client_key             = var.cluster.client_key
    cluster_ca_certificate = var.cluster.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host = var.cluster.endpoint

  client_certificate     = var.cluster.client_certificate
  client_key             = var.cluster.client_key
  cluster_ca_certificate = var.cluster.cluster_ca_certificate
}
