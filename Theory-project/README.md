# Project 1 – Multi-Environment Static Website (S3 + CloudFront) with Terraform & Ansible
## Project Overview
This project deploys a multi-environment static website platform on AWS using Terraform for infrastructure provisioning and Ansible for content synchronization.

## Architecture Diagram

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   User/Client   │────│  CloudFront CDN  │────│   Origin Access │
│                 │    │  (HTTPS Only)    │    │   Identity (OAI) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
                                                         │
┌─────────────────┐    ┌──────────────────┐             │
│   Terraform     │────│   Ansible        │             │
│   (IaC)         │    │   (Content Sync) │             │
└─────────────────┘    └──────────────────┘             │
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │   S3 Bucket     │
                                                │   (Private)     │
                                                └─────────────────┘
```

**Architecture Components:**
- **S3 Bucket**: Private bucket for storing static website content.
- **CloudFront Distribution**: CDN in front of S3 with HTTPS redirect.
- **Origin Access Identity (OAI)**: Grants CloudFront secure access to S3.
- **Terraform Modules**: Modular IaC for S3 and CloudFront.
- **Ansible**: Automates content sync to S3.

## Project Structure
```
Project1/
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── terraform.tfvars
├── .gitignore
├── modules/
│   ├── s3_site/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── cloudfront/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── localhost.yml
│   └── playbooks/
│       └── sync-site.yml
├── site/
│   ├── index.html
│   └── assets/
└── README.md
```

## Terraform Setup & Usage
1. Initialize: `terraform init`
2. Validate: `terraform validate`
3. Plan: `terraform plan -var="env=dev"`
4. Apply: `terraform apply -auto-approve -var="env=dev"`

## Ansible Usage
1. Install collection: `ansible-galaxy collection install amazon.aws`
2. Run playbook: `ansible-playbook playbooks/sync-site.yml --extra-vars "bucket_name=$BUCKET_NAME"`

## Testing Instructions
- Access CloudFront URL to verify website loads.
- Verify S3 direct access is blocked (403).

## Cleanup Instructions
- Destroy resources: `terraform destroy -var="env=dev"`

## Known Issues / Troubleshooting
- Ensure AWS credentials are configured.
- Bucket names must be globally unique.










## To find domain:
cd /workspaces/project1
echo "https://$(terraform output -raw cloudfront_domain_name)"
