# terraform setup

## Prerequisites
Besides terraform gcloud (Google Cloud SDK) has to be installed.
A key ring and a key have to be setup in KSM to encrypt the etcd database on the Application layer.

## Adjust the variables
Adjust the variables in terraform.tfvars. The following variables are provided:
* project_id: Project id of a project on GCP
* region: region where the Kubernetes cluster will be setup
* location: location/zone where the Kubernetes cluster will be setup. Has to be a zone the region that has been defined above.
* gke_ingress_machine_type: The [machine type](https://cloud.google.com/compute/docs/machine-types#predefined_machine_types) used for ingress node pool
* gke_general_machine_type: The [machine type](https://cloud.google.com/compute/docs/machine-types#predefined_machine_types) used for general node pool
* gke_min_node_count: Minimal number of node for the general node pool
* gke_max_node_count: Maximal number of node for the general node pool
* gke_release_channel: The release channel the GKE should follow. Allowed valued are RAPID, REGULAR and STABLE.
* gke_admin_cidr_block: CIDR block of IP-addresses that should have access to the Kubernetes admin console.
* gke_key_ring_name: KMS key ring name for k8s
* gke_secrets_key_name: Key encryption key used for decrypting/encrypting the k8s etcd database on the application layer
* gke_istio: Whether the istio service mesh should be enabled
* gke_network_policy: Whether network policy enforcement via Calico should be enabled

## Apply:
If not already logged in via gcloud, login:
```
gcloud auth login
```
Then apply the terraform script
```
terraform init
terraform apply
```
Afterwards you can run the init_kubectl.sh script to initialize kubectl for the created cluster. This script runs:
```
#!/bin/bash
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw location)
```
In the out/helm_values.yml-file some relevant variables are provided as output to be used by some of the helm charts.
