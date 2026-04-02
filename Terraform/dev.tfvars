# terraform/aws/environments/dev/dev.tfvars

project     = "pgagi"
region      = "ap-south-1"
root_domain = "vaidhi.sbs"

# Dev: SSH open to all (acceptable — no production data)
ssh_allowed_cidrs = ["0.0.0.0/0"]
