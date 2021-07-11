{{- define "proxyPass" -}} 
proxy_buffers 16 16k;  
proxy_buffer_size 16k;
set $upstream "http://{{ .service }}.{{ .namespace }}.svc.cluster.local:{{ .service_port }}";
proxy_pass $upstream;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
{{ .custom_nginx_config }}
{{- end }}
