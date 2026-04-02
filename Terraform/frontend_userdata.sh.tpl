#!/bin/bash
# terraform/aws/modules/ec2/templates/frontend_userdata.sh.tpl
set -euo pipefail

apt-get update -y
apt-get install -y nodejs npm git

npm install -g pm2 serve

cd /opt
git clone https://github.com/YOUR_FORK/pgagi-app.git app || true
cd /opt/app/frontend

npm install
npm run build

# Serve the built static files on port 3000
pm2 start serve --name "frontend" -- -s dist -l 3000
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

echo "ENV=${env}" >> /etc/environment
