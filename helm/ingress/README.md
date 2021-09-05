# Ingress helm chart
Helm chart to deploy a nginx reverse proxy to server as an entry point in host network mode.
This utilizes the official nginx-inc [Helm chart](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
and provides master ingress configuration for [mergeable ingress configuration](https://github.com/nginxinc/kubernetes-ingress/blob/master/examples/mergeable-ingress-types/README.md) usage.

## Variables
* domains:
  * name: The domain name for which the mergeable ingress configuration shold be setup.
  * tls_secret: Name of the k8s secret that holds the certificate credentials. Has to be of type "kubernetes.io/tls". Can be omitted if https is not used for this domain.
* nginx-ingress: See the official nginx-inc [Helm chart documentation](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/).
