locals {

  argocd_host = trim(var.argocd.url, "https://")

  oss_addons = {
    enable_argo_events           = try(var.addons.enable_argo_events, false)
    enable_argo_rollouts         = try(var.addons.enable_argo_rollouts, false)
    enable_argo_workflows        = try(var.addons.enable_argo_workflows, false)
    enable_argocd                = try(var.addons.enable_argocd, true)
    enable_cert_manager          = try(var.addons.enable_cert_manager, false)
    enable_ingress_nginx         = try(var.addons.enable_ingress_nginx, true)
    enable_keda                  = try(var.addons.enable_keda, false)
    enable_kube_prometheus_stack = try(var.addons.enable_kube_prometheus_stack, false)
    enable_kyverno               = try(var.addons.enable_kyverno, false)
    enable_metrics_server        = try(var.addons.enable_metrics_server, false)
    enable_reloader              = try(var.addons.enable_reloader, false)
    enable_vpa                   = try(var.addons.enable_vpa, false)
    enable_techmarket            = try(var.addons.enable_techmarket, false)
  }

  addons = merge(
    local.oss_addons,
  )

  addons_metadata = merge(
    module.addons_metadata.gitops_metadata,
    { cloud_provider = var.cloud_provider
      domain_name    = var.domain_name
    },
    {
      argocd_host = local.argocd_host
    },
    {
      ingress_nginx_service_type = var.addons.ingress_nginx.service_type == null ? "LoadBalancer" : var.addons.ingress_nginx.service_type
    },
    {
      addons_repo_url      = "${var.gitops.org}/${var.gitops.repo}"
      addons_repo_basepath = var.gitops.base_path
      addons_repo_path     = var.gitops.path
      addons_repo_revision = var.gitops.revision
    }
  )

  argocd_apps = {
    addons = file("${path.module}/bootstrap/addons.yaml")
  }
}
