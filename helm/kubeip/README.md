# Kubeip Helm chart
Custom Helm chart to deploy [kubeip](https://github.com/doitintl/kubeip) and set it 
up to assign a static IP to the ingress deployment. The static IPs have to be labeled with "kubeip".

## Variables
* gke:
  *  clusterName: name of the GKE cluster
  *  ingressNodePoolName: name of the node pool to which the IPs should be assigned
  *  generalNodePoolName: name of the node pool to which kubeip should be deployed
* kubeIp:
  * forceAssignment: whether to assign static IPs to existing nodes in the node pool 
  * privateKey: exported private key of the google service account that kubeip should use
