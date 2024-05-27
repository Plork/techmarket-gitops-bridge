locals {
  region                 = "schiphol-rijk"
  iam_role_policy_prefix = "sbp:${random_id.default.id}:iam::role/"
}

locals {
  techmarket_service_account = try(var.techmarket.service_account_name, "techmarket-sa")
  techmarket_namespace       = try(var.techmarket.namespace, "techmarket")
  techmarket_environment     = try(var.techmarket.environment, "development")
}

resource "random_id" "default" {
  keepers = {
    id = var.techmarket.environment
  }

  byte_length = 8
}
