# terraform/aws/environments/prod/prod.tfvars
# Non-sensitive values only. Secrets (ssh_public_key, sns_alert_arn) are
# injected via GitHub Actions secrets or `TF_VAR_*` environment variables.

project     = "pgagi"
region      = "ap-south-1"
domain      = "k8s.vaidhi.sbs"
root_domain = "vaidhi.sbs"

# Restrict SSH to your office/VPN IP in prod — never 0.0.0.0/0
ssh_allowed_cidrs = ["YOUR_OFFICE_IP/32"]
