variable "addons" {
  description = "Kubernetes addons"
  type        = any
}

variable "argocd" {
  type = object({
    url    = optional(string)
    values = optional(string)
  })
  description = "ArgoCD configuration"
}

variable "cluster" {
  type = object({
    client_certificate     = any
    client_key             = any
    cluster_ca_certificate = any
    endpoint               = any
    name                   = string
    version                = string
  })
  description = "Cluster configuration"
}


variable "cloud_provider" {
  type        = string
  description = "Cloud provider"

  validation {
    condition     = contains(["aws", "minikube"], var.cloud_provider)
    error_message = "Cloud provider must be either 'aws' or 'minikube'"
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "gitops" {
  type = object({
    base_path = string
    org       = string
    path      = string
    repo      = string
    revision  = string
  })
  description = "GitOps configuration"
}
