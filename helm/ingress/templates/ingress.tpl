{{- define "ingress" -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .name }}-master
  annotations:
    nginx.org/mergeable-ingress-type: master
    nginx.org/server-snippets: |
      # nginx doest not support multiple if statements
      set $redirect false;
      if ($scheme = http) {
        set $redirect true;
      }
      if ($uri ~ ^/\.well-known/acme-challenge.*) {
        set $redirect false;
      }
      if ($redirect = true) {
        return 308 https://$host:443$request_uri;
      }
{{- if .server_snippets -}}
{{ .server_snippets | indent 6 }}
{{- end}}
spec:
  ingressClassName: {{ .ingress_class_name }}
  tls:
  - hosts:
    - {{ .name }}
    secretName: certbot-{{ .common_name }}
  rules:
  - host: {{ .name }}
{{- end}}
