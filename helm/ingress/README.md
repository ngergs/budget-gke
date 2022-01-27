# Ingress helm chart
Helm chart to deploy a nginx reverse proxy to server as an entry point in host network mode.
This utilizes the official nginx-inc [Helm chart](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
and provides master ingress configuration for [mergeable ingress configuration](https://github.com/nginxinc/kubernetes-ingress/blob/master/examples/mergeable-ingress-types/README.md) usage.
As issuer for the SSL certificates LetsEncrypt and cert-manager is used. Hence, cert-manager has to be installed before this chart can be deployed. Like so (assumming the namespace ingress exists):
```
helm install cert-manager jetstack/cert-manager -f values-cert-manager.yml
helm install ingress . -n ingress -f values.yml -f ../../terraform/out/helm_values.yml
```

## Server snippets
Our whole setup uses server snippets in various ways. This is ok in the context of a single-user dev-cluster, but may carry significant security risks for setups that involve more users.
However, for those more serious setups this whole project is not really the right fit. For details regarding the security risks see [this github issue](https://github.com/kubernetes/ingress-nginx/issues/7837).

## Variables
* issuer:
  * email: E-Mail as contact for LetsEncrypt for relevant informations about certificate renewal etc.
* domains:
  * names: For both common_name and subject_alternative_names a mergeable ingress master is setup. Hence, collisions are not supported.
    * common_name: The common name of the certificate.
    * subject_alternative_names: List of subjec alternative names for the certificate. 
  * letsencrypt_prod: Boolean whether the LetsEncrypt prod or staging CA should be used. The productive LetsEncrypt endpoint issues the actual browser supported certificated, but has rather strict [rate limits](https://letsencrypt.org/docs/rate-limits/) and should not be used for testing purposes.
  * server_snippets: Used to fille the nginx.org/server-snippets annotation of the master ingress configurations.
  * robots: Whether to automatically setup up a minimalistic nginx that serves a /robots.txt-file.
    * entries: List of entries for the robots.txt
      * user_agent: User-agent entry
      * Allow: List of Allow entries
      * Disallow: List of Disallow entries
    * sitemap: List of sitemap entries
    * replicaCount: Replica-Count of the aforementioned nginx deployment. Defaults to 1.

* nginx-ingress: See the official nginx-inc documentation. The values.yml provides a set of useful defaults.
  * [Nginx-inc Ingress Helm chart](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
  * [Advanced Configuration with Annotations](https://docs.nginx.com/nginx-ingress-controller/configuration/ingress-resources/advanced-configuration-with-annotations/)
  * [Config Map Resource](https://docs.nginx.com/nginx-ingress-controller/configuration/global-configuration/configmap-resource/#listeners)
