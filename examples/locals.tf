locals {
  account_id       = data.aws_caller_identity.current.account_id
  cluster_version  = data.aws_eks_cluster.this.version
  region           = data.aws_region.current.name
  route53_zone_arn = try(data.aws_route53_zone.domain.arn, "")
  vpc_id           = data.aws_eks_cluster.this.vpc_config[0].vpc_id

  argocd_host = trim(var.argocd.url, "https://")

  argocd_oidc_config = var.argocd.okta != null ? {
    argocd_oidc_config = true
    argocd_oidc_issuer = var.argocd.okta.org_url
    } : {
    argocd_oidc_config = false
  }

  // These are not yet implemented yet
  aws_addons = {
    enable_aws_cloudwatch_metrics                = try(var.addons.enable_aws_cloudwatch_metrics, false)
    enable_aws_otel_collector                    = try(var.addons.enable_aws_otel_collector, false)
    enable_aws_ebs_csi_resources                 = try(var.addons.enable_aws_ebs_csi_resources, false)
    enable_aws_efs_csi_driver                    = try(var.addons.enable_aws_efs_csi_driver, false)
    enable_aws_for_fluentbit                     = try(var.addons.enable_aws_for_fluentbit, false)
    enable_aws_fsx_csi_driver                    = try(var.addons.enable_aws_fsx_csi_driver, false)
    enable_aws_gateway_api_controller            = try(var.addons.enable_aws_gateway_api_controller, false)
    enable_aws_load_balancer_controller          = try(var.addons.enable_aws_load_balancer_controller, false)
    enable_aws_managed_service_prometheus        = try(var.addons.enable_aws_managed_service_prometheus, false)
    enable_aws_node_termination_handler          = try(var.addons.enable_aws_node_termination_handler, false)
    enable_aws_privateca_issuer                  = try(var.addons.enable_aws_privateca_issuer, false)
    enable_aws_secrets_store_csi_driver_provider = try(var.addons.enable_aws_secrets_store_csi_driver_provider, false)
    enable_cert_manager                          = try(var.addons.enable_cert_manager, false)
    enable_cluster_autoscaler                    = try(var.addons.enable_cluster_autoscaler, false)
    enable_external_dns                          = try(var.addons.enable_external_dns, false)
    enable_external_secrets                      = try(var.addons.enable_external_secrets, false)
    enable_gitlab_runner                         = try(var.addons.enable_gitlab_runner, false)
    enable_hubble                                = try(var.addons.enable_hubble, false)
    enable_karpenter                             = try(var.addons.enable_karpenter, false)
    enable_loki_stack                            = try(var.addons.enable_loki_stack, false)
  }

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
      configuration_values = jsonencode({
        customLabels = merge(var.labels, { application = "aws-ebs-csi-driver" })
      })
    }
    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        podLabels = merge(var.labels, { application = "core-dns" })
      })
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
      configuration_values = jsonencode({
        podLabels = merge(var.labels, { application = "kube-proxy" })
      })
    }
  }

  oss_addons = {
    enable_argo_events              = try(var.addons.enable_argo_events, false)
    enable_argo_rollouts            = try(var.addons.enable_argo_rollouts, false)
    enable_argo_workflows           = try(var.addons.enable_argo_workflows, false)
    enable_argocd                   = try(var.addons.enable_argocd, true)
    enable_cilium                   = try(var.addons.enable_cilium, true)
    enable_cilium_clusterwide_cnp   = try(var.addons.enable_cilium_clusterwide_cnp, false)
    enable_gatekeeper               = try(var.addons.enable_gatekeeper, false)
    enable_kube_prometheus_stack    = try(var.addons.enable_kube_prometheus_stack, false)
    enable_loki                     = try(var.addons.enable_loki, false)
    enable_grafana_operator         = try(var.addons.enable_grafana_operator, false)
    enable_kyverno                  = try(var.addons.enable_kyverno, false)
    enable_kyverno_policies         = try(var.addons.enable_kyverno_policies, false)
    enable_metrics_server           = try(var.addons.enable_metrics_server, false)
    enable_prometheus_node_exporter = try(var.addons.enable_prometheus_node_exporter, false)
    enable_secrets_store_csi_driver = try(var.addons.enable_secrets_store_csi_driver, false)
    enable_vpa                      = try(var.addons.enable_vpa, false)
    enable_keda                     = try(var.addons.enable_keda, false)
    enable_tf_operator              = try(var.addons.enable_tf_operator, false)
    enable_reloader                 = try(var.addons.enable_reloader, false)
    enable_kubescape                = try(var.addons.enable_kubescape, false)
    enable_grafana_operator         = try(var.addons.enable_grafana_operator, false)
  }

  addons = merge(
    local.oss_addons,
    local.aws_addons,
    { cluster_version = local.cluster_version },
    { aws_cluster_name = var.cluster_name }
  )

  addons_metadata = merge(
    module.eks_blueprints_addons.gitops_metadata,
    module.eks_sbp_addons.gitops_metadata,
    module.hubble.gitops_metadata,
    local.argocd_oidc_config,
    { ingress_security_group = var.ingress_security_group },
    { cloud_provider = var.cloud_provider },
    {
      aws_cluster_name = var.cluster_name
      aws_region       = local.region
      aws_account_id   = local.account_id
      aws_vpc_id       = local.vpc_id
    },
    {
      argocd_host                 = local.argocd_host
      external_dns_domain_filters = "[${var.domain_name}]"
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
