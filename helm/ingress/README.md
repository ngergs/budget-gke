# Ingress Helm chart
Custom Helm chart to deploy a nginx reverse proxy to server as an entry point in host network mode.

## Variables
* replicaCount: number of replicas to deploy
* https:
  * enabled: Whether the https endpoints are enabled.
  * cert_secret_name: name of the Kubernetes secret, that holds the TLS certificate. Has to be of type "kubernetes.io/tls".
  * ssl_dhparams_filepath: path for a .pem file that obtains the ssl_dhparams, generate  e.g. via
    ```
    openssl dhparam -out dhparam.pem 4096
    ```
  * hsts:
    * enabled: Whether [HSTS](https://datatracker.ietf.org/doc/html/rfc6797) is enabled
    * max_age: The max_age for HSTS, only relevant if HSTS is enabled (see above)
  * expect_ct:
    * enabled: Whether the [Expect-CT](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect-CT) header should be send
    * max_age: The max_age for Expect-CT, only relevant if Expect-CT is enabled(see above)
* domains: Block below is a list
  * names: list(!) of domains for which this configuration block holds
  * http: Also a list
      * path: subpath that should be served via HTTP
      * service: Kubernetes service that should be served under the given subpath
      * service_port: port of the aforementioned Kubernetes service
      * namespace: namespace of the aforementioned Kubernetes service
      * custom_nginx_config: additional nginx configs to be added. see templates/configmap.yml to seethe details of the nginx reverse proxy config.
  * https: Also a list
      * path: subpath that should be served via HTTP
      * service: Kubernetes service that should be served under the given subpath
      * service_port: port of the aforementioned Kubernetes service
      * namespace: namespace of the aforementioned Kubernetes service
      * custom_nginx_config: additional nginx configs to be added. see templates/configmap.yml to seethe details of the nginx reverse proxy config.
* gke:
  * ingressNodePoolName: Name of the node pool on which the ingress should be deployed. Deployments tolerate the "ingress" taint.
