# terraform/aws/environments/staging/staging.tfvars

project     = "pgagi"
region      = "ap-south-1"
root_domain = "vaidhi.sbs"

# Staging: restrict SSH to known IPs
ssh_allowed_cidrs = ["YOUR_OFFICE_IP/32"]
