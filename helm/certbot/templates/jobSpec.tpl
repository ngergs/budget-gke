{{- define "jobSpec" -}} 
spec:
  backoffLimit: 0
  template:
    metadata:
      name: certbot
      labels:
        app: certbot
    spec:
      serviceAccountName: certbot
      restartPolicy: Never
      containers:
       - name: certbot
         image: certbot/certbot
         imagePullPolicy: Always
         command: ["/bin/sh"]
         args: ["-c", "/home/root/exec/run.sh"]
         ports:
           - name: http
             containerPort: 80
             protocol: TCP
         volumeMounts:
           - name: run-script
             mountPath: /home/root/exec
             readOnly: true
      volumes:
        - configMap:
            name: certbot-{{ .common_name }}
            defaultMode: 0777
          name: run-script
{{- end }}
