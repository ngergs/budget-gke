{{- define "ssl" -}} 
# SSL settings
ssl_certificate /etc/letsencrypt/cert/tls.crt; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/cert/tls.key; # managed by Certbot
ssl_dhparam /etc/letsencrypt/dhparams/ssl-dhparams.pem;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:10m;  # about 40000 sessions
ssl_session_tickets off;

# ssl config from mozilla https://ssl-config.mozilla.org/
# intermediate configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
ssl_prefer_server_ciphers off;

# OCSP stapling
ssl_stapling on;
ssl_stapling_verify on;
{{- end }}
