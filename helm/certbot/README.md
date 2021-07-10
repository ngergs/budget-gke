# Certbot Helm chart
Custom Helm chart to deploy the Certbot image as a cronjob, obtain a LetsEncrypt certificate and store it in k8s. For our setup we cannot use cert-manager as we are
using a custom ingress deployment as we avoid the GKE cloud load balancer for cost reasons (development setup!).
The certificate will be refreshed on the first of the month.
A initial job will be scheduled immediately after deployment to obtain an initial certificate.

## Variables
* namespace: Kubernetes namespace in which the Certbot will run and where the secret should be stored.
* test_cert: Call the test LetsEncrypt endpoint to check if everything works without risking exhausting the API limits of the productive LetsEncrypt endpoint.
* domains: List(!) of domains for which a TLS certificate should be obtained
* contact_mail: For LetsEncrypt to contact you, e.g. when your certificate is on the risk to expire of if other problems occur.
