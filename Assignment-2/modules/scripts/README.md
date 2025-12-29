# Assignment 2 - Multi-Tier Web Infrastructure

## 📋 Project Overview
This project deploys a high-availability multi-tier web infrastructure on AWS using Terraform. It includes an Nginx reverse proxy/load balancer and three Apache backend servers.

### Architecture
- **VPC & Networking**: Custom VPC, public subnet, IGW, and route tables.
- **Security**: Granular security groups for Nginx (frontend) and Backend servers.
- **Compute**:
  - 1 x Nginx Server (Reverse Proxy, SSL, Caching).
  - 3 x Backend Apache Servers (Web-1, Web-2, Web-3).
- **Automation**: Cloud-init scripts (`user_data`) for automatic software provisioning.

---

## 🛠️ Prerequisites
- **Terraform**: v1.0+ installed.
- **AWS CLI**: Configured with valid credentials (`aws configure`).
- **SSH Key pair**: An existing local SSH key (e.g., `~/.ssh/id_rsa`).

---

## 🚀 Deployment Instructions

### 1. Configure Variables
1. Rename `terraform.tfvars.example` (if applicable) or edit `terraform.tfvars`:
   ```hcl
   public_key  = "~/.ssh/id_rsa.pub"
   private_key = "~/.ssh/id_rsa"
   # ensure other variables like specific IPs match your needs
   ```

### 2. Initialize & Deploy
Run the following commands in the project root:

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply configuration
terraform apply -auto-approve
```

### 3. Post-Deployment Configuration
After `terraform apply` finishes, you will see a **Configuration Guide** in the outputs. Follow these steps:

1.  **SSH into Nginx**:
    ```bash
    ssh -i <path-to-private-key> ec2-user@<nginx-public-ip>
    ```
2.  **Update Nginx Config**:
    ```bash
    sudo vim /etc/nginx/nginx.conf
    ```
    Replace the placeholder IPs in the `upstream backend_servers` block with the **Private IPs** of your backend servers (provided in the terraform output).
    ```nginx
    upstream backend_servers {
        server 10.0.x.x:80; # Web-1
        server 10.0.x.y:80; # Web-2
        server 10.0.x.z:80 backup; # Web-3
    }
    ```
3.  **Restart Nginx**:
    ```bash
    sudo systemctl restart nginx
    ```

---

## 🧪 Testing & Verification

### Load Balancing
- Access `https://<nginx-public-ip>` in your browser.
- Refresh multiple times. You should see the hostname change between **web-1** and **web-2**.
- **web-3** will not appear unless both web-1 and web-2 are down.

### Caching
- Open Developer Tools (Network Tab).
- First request: `X-Cache-Status: MISS` (Header).
- Second request: `X-Cache-Status: HIT`.

### High Availability
1. Stop Apache on Web-1: `sudo systemctl stop httpd`.
2. Traffic should flow to Web-2.
3. Stop Apache on Web-2.
4. Traffic should failover to **Web-3** (Backup).

---

## 🧹 Cleanup
To destroy all resources and avoid costs:

```bash
terraform destroy -auto-approve
```
Verify in AWS Console that all instances and VPC components are terminated.
