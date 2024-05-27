// FIXME
variable "addons" {
  type        = map(string)
  default     = { enable_metrics_server = true }
  description = "Kubernetes addons"
}

variable "apps" {
  description = "argocd app of apps to deploy"
  type        = any
  default     = {}
}

variable "chart_repository" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
  description = "URL of the ArgoCD Helm chart repository"
}

variable "chart_version" {
  type        = string
  default     = "6.0.1"
  description = "Version of the ArgoCD Helm chart to deploy"
}

variable "cluster_name" {
  type        = string
  default     = "in-cluster"
  description = "Name of the EKS cluster"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "metadata" {
  type        = map(string)
  description = "Additional metadata to pass to the Argo"
}

variable "repo_credentials" {
  type = map(object({
    username = string
    password = string
    url      = string
  }))
  default     = {}
  description = "Map of repository credentials"
}

variable "url" {
  type        = string
  default     = null
  description = "URL of the ArgoCD instance"
}
