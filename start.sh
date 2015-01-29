#!/bin/bash

count=`find /etc/ssl/private/ -type f -a -name \*.pem 2>/dev/null |wc -l`
if [ $count -eq 0 ]; then
   make-ssl-cert generate-default-snakeoil
   cat /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/certs/ssl-cert-snakeoil.pem > /etc/ssl/private/server.pem
fi

mkdir -p /var/run/pound

cat>/etc/pound/pound.cfg<<EOF
User            "www-data"
Group           "www-data"
LogLevel        3
Alive           30
Control 	"/var/run/pound/poundctl.socket"
Daemon 		0

ListenHTTP
    RewriteLocation 1
    Port 80
End

ListenHTTPS
    xHTTP 1
    Address 0.0.0.0
    Port    443
EOF
for c in /etc/ssl/private/*.pem; do
   echo "    Cert    \"$c\"" >> /etc/pound/pound.cfg
done
cat>>/etc/pound/pound.cfg<<EOF
    
    Ciphers "ECDHE-RSA-AES128-SHA256:AES128-GCM-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH"
    
    Service
        URL "^(/|.*)\$"
        Redirect "${URL}"
    End 
End
EOF

/usr/sbin/pound
