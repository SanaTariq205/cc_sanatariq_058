# Troubleshooting Guide

## Common Issues and Solutions

### Terraform Issues

#### Error: "Bucket already exists"
**Symptoms**: `terraform apply` fails with bucket name conflict
**Cause**: S3 bucket names must be globally unique
**Solution**:
1. Change the bucket name in `terraform.tfvars`
2. Or modify the naming convention in `locals.tf`

#### Error: "Access Denied" during apply
**Symptoms**: Terraform fails to create AWS resources
**Cause**: AWS credentials not configured or insufficient permissions
**Solution**:
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region (us-east-1)
```

#### Error: "No valid credential sources found"
**Symptoms**: Terraform cannot authenticate with AWS
**Cause**: AWS credentials missing or expired
**Solution**:
1. Check `~/.aws/credentials` file
2. Re-run `aws configure` with valid credentials
3. Ensure IAM user has required permissions (S3, CloudFront)

#### Error: "CloudFront distribution still deploying"
**Symptoms**: Destroy fails because CloudFront is still deploying
**Cause**: CloudFront distributions take time to deploy/disable
**Solution**: Wait 10-15 minutes and retry `terraform destroy`

### Ansible Issues

#### Error: "amazon.aws collection not installed"
**Symptoms**: Playbook fails with collection not found
**Cause**: Required Ansible collection missing
**Solution**:
```bash
ansible-galaxy collection install amazon.aws
```

#### Error: "botocore not found"
**Symptoms**: Ansible fails with import error
**Cause**: Python boto3/botocore not installed
**Solution**:
```bash
pip install boto3 botocore
```

#### Error: "bucket_name variable not set"
**Symptoms**: Ansible playbook fails with undefined variable
**Cause**: BUCKET_NAME environment variable not set
**Solution**:
```bash
export BUCKET_NAME=$(terraform output -raw bucket_name)
ansible-playbook playbooks/sync-site.yml --extra-vars "bucket_name=$BUCKET_NAME"
```

#### Error: "Access denied" during sync
**Symptoms**: Ansible cannot upload to S3
**Cause**: AWS credentials not available to Ansible
**Solution**:
1. Ensure AWS credentials are configured (same as Terraform)
2. Check IAM permissions include S3 write access

### S3 and CloudFront Issues

#### Direct S3 access returns 403 (Expected)
**Symptoms**: Cannot access `https://bucket-name.s3.amazonaws.com/index.html`
**Status**: This is correct behavior for private bucket
**Verification**: Use CloudFront URL instead

#### CloudFront returns 403 or 404
**Symptoms**: CloudFront URL not working
**Cause**: Possible issues:
- OAI not properly configured
- Bucket policy incorrect
- Content not uploaded
**Solution**:
1. Check CloudFront distribution status in AWS Console
2. Verify OAI in bucket policy matches CloudFront OAI
3. Ensure content is uploaded: `aws s3 ls s3://bucket-name/`

#### Website not loading after deployment
**Symptoms**: CloudFront URL returns error
**Cause**: Content not synced or bucket empty
**Solution**:
1. Check bucket contents: `aws s3 ls s3://bucket-name/`
2. Re-run Ansible sync if needed
3. Wait for CloudFront cache invalidation (can take 5-10 minutes)

### General Issues

#### Command not found errors
**Symptoms**: `terraform`, `ansible`, `aws` commands not found
**Cause**: Tools not installed or not in PATH
**Solution**:
```bash
# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install Ansible
sudo apt update && sudo apt install ansible

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

#### Permission denied on files
**Symptoms**: Cannot read/write project files
**Cause**: File permissions issue
**Solution**:
```bash
chmod -R 755 /workspaces/project1
```

### Debugging Commands

#### Check AWS Resources
```bash
# List S3 buckets
aws s3 ls

# List bucket contents
aws s3 ls s3://bucket-name/

# Check CloudFront distributions
aws cloudfront list-distributions --query 'DistributionList.Items[*].{ID:Id,Domain:DomainName,Status:Status}'
```

#### Terraform Debugging
```bash
# Show current state
terraform show

# List resources
terraform state list

# Refresh state
terraform refresh
```

#### Ansible Debugging
```bash
# Run with verbose output
ansible-playbook playbooks/sync-site.yml -v

# Check Ansible version and collections
ansible --version
ansible-galaxy collection list
```

### Getting Help

If issues persist:
1. Check AWS Console for resource status
2. Review CloudWatch logs for errors
3. Verify all prerequisites are met
4. Check network connectivity to AWS services
5. Ensure region is set correctly (us-east-1)