# budget-gke
This follows a [blog post](https://redmaple.tech/blogs/affordable-kubernetes-for-personal-projects/) from David Grifiiths how to setup a Kubernetes cluster at google while minimizing the cost. The result is a development-cluster which is very useful for toy projects or experiments, but should not be used for production purposes.

## Differences to the blog post
While in the aforementioned blogpost the Kubernetes cluster is setup manually here we have automated everything using Terraform and Helm charts. Furthermore the blog post did skip the part of obtaining SSL certificates. We provide a simple LetsEncrypt-based [Certbot](https://github.com/certbot/certbot)-deployment that is compatible with the limitations of the development cluster (no k8s ingress) and works fully automatic.

## What is setup
A budget-oriented development Kubernetes cluster. The cluster nodes are marked as being preemptible by default. This reduces costs, but may lead to some downtime.
The main work and cost-saving aspect besides the nodes being preemptible is the avoidance of requiring a cloud load balancer. For this purpose a static IP is reserved via Terraform. The cluster uses two node pools, one is tainted for ingress purposes only and the other one is for general usage. [Kubeip](https://github.com/doitintl/kubeip) (deployed via Helm) is used to attach the static IP address to the single node in the ingress tainted node pool. On this a custom nginx reverse proxy is deployed to serve as ingress. [Certbot](https://github.com/certbot/certbot) is used to obtain a LetsEncrypt certificate and store it as Kubernetes secret. The requirement of the deployment to run via host network yields to some limitations, e.g. this setup is to my knowledge not compatible with Istio or Calico.

## Usage
1. Setup the cluster using Terraform, see the readme in the Terraform subfolder.
2. Deploy the relevant Helm charts, again the readme in the Helm subfolders provides further details.
