# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "region" {
  value       = "asia-southeast1"
  description = "GCloud Region"
}

output "project_id" {
  value       = "tidy-jetty-361006"
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.standard_cluster.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.standard_cluster.endpoint
  description = "GKE Cluster Host"
}