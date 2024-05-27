locals {
  annotations = {
    "argocd.argoproj.io/compare-options" = "IgnoreExtraneous"
    "argocd.argoproj.io/sync-options"    = "Prune=false,Delete=false"
  }

  labels = merge(
    {
      "app.kubernetes.io/instance"  = "argocd"
      "argocd.argoproj.io/instance" = "argocd"
    },
  )
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name        = "argocd"
    annotations = local.annotations
    labels      = local.labels
  }
}

resource "kubernetes_secret" "cluster" {
  metadata {
    name      = var.cluster_name
    namespace = kubernetes_namespace.argocd.id

    annotations = merge(
      local.annotations,
      var.metadata,
      {
        cluster_name = var.cluster_name
        environment  = var.environment
      },
    )

    labels = merge(
      local.labels,
      {
        "argocd.argoproj.io/secret-type" = "cluster"
        cluster_name                     = var.cluster_name
        enable_argocd                    = true
        environment                      = var.environment
      },
      var.addons,
    )
  }

  data = {
    name   = var.cluster_name
    server = "https://kubernetes.default.svc"
  }

  depends_on = [helm_release.argocd]
}

resource "helm_release" "argocd" {
  chart            = "argo-cd"
  create_namespace = true
  name             = "argo-cd"
  namespace        = kubernetes_namespace.argocd.id
  repository       = var.chart_repository
  skip_crds        = false
  version          = var.chart_version

  values = [
    <<-EOT
    global:
      cm:
        resource.customizations: |
          argoproj.io/Application:
            health.lua: |
              hs = {}
              hs.status = "Progressing"
              hs.message = ""
              if obj.status ~= nil then
                if obj.status.health ~= nil then
                  hs.status = obj.status.health.status
                  if obj.status.health.message ~= nil then
                    hs.message = obj.status.health.message
                  end
                end
              end
              return hs
    EOT
  ]

  // Override helm release to "argo-cd"
  set {
    name  = "fullnameOverride"
    value = "argo-cd"
  }
}

resource "helm_release" "bootstrap" {
  for_each = var.apps

  name      = each.key
  namespace = kubernetes_namespace.argocd.id
  chart     = "${path.module}/charts/resources"
  version   = "1.0.0"

  values = [
    <<-EOT
    resources:
      - ${indent(4, each.value)}
    EOT
  ]

  depends_on = [resource.kubernetes_secret.cluster]
}
