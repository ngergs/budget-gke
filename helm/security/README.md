# Pod security policies
Deploys the [pod security standard policies](https://kubernetes.io/docs/concepts/security/pod-security-standards/) and adds them to namespaces and service accounts.
Additional policies can easily be added to the template folder by following the naming schema psp-\{pod-security-name}.yml.

## Variables
* {policy name; privileged, baseline and restricted are supported without modification}:
   * namespace: List of namespaces for which the policy should apply
   * serviceaccounts: List of service account for which this policy should apply
     * name: service account name
     * namespace: namespace of the service account
