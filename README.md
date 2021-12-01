# budget-gke
This follows a [blog post](https://redmaple.tech/blogs/affordable-kubernetes-for-personal-projects/) from David Grifiiths how to setup a Kubernetes cluster at google while minimizing the cost. The result is a development-cluster which is very useful for toy projects or experiments, but should not be used for production purposes.

## Differences to the blog post
While in the aforementioned blog post the Kubernetes cluster is setup manually here we have automated everything using Terraform and Helm charts.
Furthermore, in the blog post a hand crafted configured nginx reverse proxy has been deployed to act as ingress. Here we use the free nginx-inc ingress and deploy it on the ingress node pool. 
This allows the app deployments to specify the reverse proxy routings in their own ingress deployments. This heavily reduces the coupling between the ingress deployment and the application deployments.
Having a complete working ingress setup allows us to also fully automate the certificate management. To do so we use [LetsEncrypt](https://letsencrypt.org/) with [cert-manager](https://cert-manager.io/) for automatic SSL certificate management.

## A budget-oriented development Kubernetes cluster.
The cluster nodes are marked as being preemptible by default. This reduces costs, but may lead to some downtime.
The main work and cost-saving aspect besides the nodes being preemptible is the avoidance of requiring a cloud load balancer. For this purpose a static IP is reserved via Terraform. The cluster uses two node pools, one is used by the ingress controller via node selectors and the other one is for additional general usage. [Kubeip](https://github.com/doitintl/kubeip) (deployed via Helm) is used to attach the static IP address to the single node in the ingress node pool. The nginx-inc ingress deployment (the controller pods) is deployed in this node pool. [cert-manager](https://cert-manager.io/) is used to obtain a [LetsEncrypt](https://letsencrypt.org/) certificate and store it as Kubernetes secret.

## Usage
1. Setup the cluster using Terraform, see the readme in the Terraform subfolder.
2. Deploy the relevant Helm charts, again the readme in the Helm subfolders provides further details.
