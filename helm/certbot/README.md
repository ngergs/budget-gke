# Certbot Helm chart
Custom Helm chart to deploy the Certbot image as a cronjob, obtain a LetsEncrypt certificate and store it in k8s. For our setup we cannot use cert-manager as we are
using a custom ingress deployment as we avoid the GKE cloud load balancer for cost reasons (development setup!).
The certificate will be refreshed on the first of the month.
A initial job will be scheduled immediately after deployment to obtain an initial certificate.

## Variables
* test_cert: Call the test LetsEncrypt endpoint to check if everything works without risking exhausting the API limits of the productive LetsEncrypt endpoint.
* domains: List of domains for which a TLS certificate should be obtained, structure is as follows:
  * common_name: Common Name for the domain, i.e. the main domain name being used
  * subject_alternative_names: Further (sub-)domains for which the certificate should be valid
  * contact_mail: For LetsEncrypt to contact you, e.g. when your certificate is on the risk to expire of if other problems occurs.
  * secret_name: Name of the Kubernetes secret in which the certificate credentials should be stored.
