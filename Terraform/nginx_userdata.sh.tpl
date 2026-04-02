#!/bin/bash
# terraform/aws/modules/ec2/templates/nginx_userdata.sh.tpl
set -euo pipefail

apt-get update -y
apt-get install -y nginx certbot python3-certbot-nginx

# Write NGINX config
cat > /etc/nginx/sites-available/pgagi <<'NGINX'
upstream frontend {
    server ${frontend_private_ip}:3000;
    keepalive 32;
}

upstream backend {
    server ${backend_private_ip}:8000;
    keepalive 32;
}

server {
    listen 80;
    server_name ${domain};

    # Rate limiting (override per env via separate conf if needed)
    limit_req_zone $binary_remote_addr zone=api:10m rate=30r/s;

    location / {
        proxy_pass         http://frontend;
        proxy_http_version 1.1;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   Connection "";
    }

    location /api/ {
        limit_req zone=api burst=20 nodelay;
        proxy_pass         http://backend;
        proxy_http_version 1.1;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   Connection "";
    }

    location /api/health {
        proxy_pass http://backend/api/health;
        access_log off;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/pgagi /etc/nginx/sites-enabled/pgagi
rm -f /etc/nginx/sites-enabled/default

nginx -t && systemctl enable nginx && systemctl restart nginx
