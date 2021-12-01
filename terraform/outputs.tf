output "ingress_ip_address" {
  value = google_compute_address.ingress.address
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "location" {
  value = var.location
}

locals {
  helm_values = templatefile("${path.module}/templates/helm_values.yml", {
    gkeClusterName         = google_container_cluster.primary.name
    gkeIngressNodePoolName = google_container_node_pool.ingress_nodes.name
    gkeKubeIpNodePoolName  = google_container_node_pool.primary_nodes.name
    kubeIpPrivateKey       = google_service_account_key.kube_ip.private_key
  })
}

resource "local_file" "helm_file" {
  content  = local.helm_values
  filename = "out/helm_values.yml"
}
