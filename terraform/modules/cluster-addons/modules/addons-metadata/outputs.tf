output "gitops_metadata" {
  description = "GitOps Bridge metadata"
  value = merge(
    { for k, v in {
      iam_role        = "${local.iam_role_policy_prefix}-techmarket-role-${local.techmarket_environment}"
      namespace       = local.techmarket_namespace
      service_account = local.techmarket_service_account
      environment     = local.techmarket_environment
      } : "techmarket_${k}" => v if var.enable_techmarket
    }
  )
}
