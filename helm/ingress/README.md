# Ingress helm chart
Helm chart to deploy a nginx reverse proxy to server as an entry point in host network mode.
This utilizes the official nginx-inc [Helm chart](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
and provides master ingress configuration for [mergeable ingress configuration](https://github.com/nginxinc/kubernetes-ingress/blob/master/examples/mergeable-ingress-types/README.md) usage.
As issuer for the SSL certificates LetsEncrypt and cert-manager is used. Hence, cert-manager has to be installed before this chart can be deployed. Like so (assumming the namespace ingress exists):
```
helm install cert-manager jetstack/cert-manager -f values-cert-manager.yml
helm install ingress . -n ingress -f values.yml -f ../../terraform/out/helm_values.yml
```


## Variables
* issuer:
  * email: E-Mail as contact for LetsEncrypt for relevant informations about certificate renewal etc.
* domains:
  * names: List of domain names for which the mergeable ingress configuration shold be setup.
  * letsencrypt_prod: Boolean whether the LetsEncrypt prod or staging CA should be used.
  * server_snippets: Used to fille the nginx.org/server-snippets annotation of the master ingress configurations.
* nginx-ingress: See the official nginx-inc documentation. The values.yml provides a set of useful defaults.
  * [Nginx-inc Ingress Helm chart](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
  * [Advanced Configuration with Annotations](https://docs.nginx.com/nginx-ingress-controller/configuration/ingress-resources/advanced-configuration-with-annotations/)
  * [Config Map Resource](https://docs.nginx.com/nginx-ingress-controller/configuration/global-configuration/configmap-resource/#listeners)
