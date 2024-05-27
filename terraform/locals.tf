locals {
  domain_name = "localdev.me"

  cluster = {
    name    = "techmarket"
    version = "1.28"
    addons = {
      enable_argo_rollouts         = false
      enable_argo_workflows        = false
      enable_cert_manager          = false
      enable_ingress_nginx         = true
      enable_keda                  = true
      enable_kube_prometheus_stack = false
      enable_kyverno               = false
      enable_metrics_server        = false
      enable_reloader              = false
      enable_techmarket            = false
      enable_vpa                   = false

      techmarket = {
        environment = "development"
      }

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
