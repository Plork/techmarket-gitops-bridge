locals {
  domain_name = "localtest.me"

  cluster = {
    name    = "minikube"
    version = "1.32"
    addons = {
      enable_argo_rollouts  = true
      enable_cert_manager   = true
      enable_ingress_nginx  = true
      enable_kargo          = true
      enable_metrics_server = true

      ingress_nginx = {
        service_type = "NodePort"
      }
    }

    argocd = {
      url = "https://argocd.${local.domain_name}"
    }

    gitops = {
      base_path = "kubernetes/"
      org       = "https://github.com"
      path      = "bootstrap/control-plane/addons"
      repo      = "plork/techmarket-gitops-bridge.git"
      revision  = "main"
    }
  }
}
