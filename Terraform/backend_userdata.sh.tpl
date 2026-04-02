#!/bin/bash
# terraform/aws/modules/ec2/templates/backend_userdata.sh.tpl
set -euo pipefail

apt-get update -y
apt-get install -y nodejs npm git

# Install PM2 for process management
npm install -g pm2

# Clone / pull latest backend code
# (In prod, use CodeDeploy or pull from S3 artifact — this is a dev-friendly bootstrap)
cd /opt
git clone https://github.com/YOUR_FORK/pgagi-app.git app || true
cd /opt/app/backend

npm install --production

# Start with PM2
pm2 start npm --name "backend" -- start
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

# Environment label (for health endpoint enrichment if needed)
echo "ENV=${env}" >> /etc/environment
