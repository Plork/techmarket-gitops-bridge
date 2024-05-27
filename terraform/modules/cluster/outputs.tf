output "name" {
  description = "The Kubernetes cluster name"
  value       = var.cluster_name
}

output "version" {
  description = "The Kubernetes cluster version"
  value       = var.cluster_version
}

output "kubeconfig" {
  description = "The Kubernetes cluster kubeconfig"
  value       = kind_cluster.default.kubeconfig
}

output "endpoint" {
  description = "The Kubernetes cluster endpoint"
  value       = kind_cluster.default.endpoint
}

output "client_certificate" {
  description = "The Kubernetes cluster client certificate"
  value       = kind_cluster.default.client_certificate
}

output "client_key" {
  description = "The Kubernetes cluster client key"
  value       = kind_cluster.default.client_key
}

output "cluster_ca_certificate" {
  description = "The Kubernetes cluster CA certificate"
  value       = kind_cluster.default.cluster_ca_certificate
}
