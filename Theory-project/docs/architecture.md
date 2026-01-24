# Architecture Documentation

## Overview
This document provides detailed information about the architecture of the Multi-Environment Static Website deployment on AWS using Terraform and Ansible.

## High-Level Architecture

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

## Components

### AWS S3 Bucket
- **Purpose**: Stores static website content (HTML, CSS, JS, images)
- **Configuration**:
  - Private bucket (no public access)
  - Server-side encryption (AES256)
  - Versioning disabled
  - Public access blocks enabled
- **Security**: Only accessible via CloudFront through Origin Access Identity

### AWS CloudFront Distribution
- **Purpose**: Content Delivery Network (CDN) for global distribution
- **Configuration**:
  - HTTPS redirect (viewer protocol policy)
  - Default cache behavior for static content
  - Origin: S3 bucket with OAI
  - Price class: All edge locations
- **Benefits**: Faster content delivery, reduced latency, SSL termination

### Origin Access Identity (OAI)
- **Purpose**: Grants CloudFront secure access to private S3 bucket
- **Configuration**: IAM user-like entity for CloudFront to access S3
- **Security**: Eliminates need for public S3 bucket while allowing CloudFront access

### Terraform Infrastructure
- **Purpose**: Infrastructure as Code for provisioning AWS resources
- **Modules**:
  - `s3_site`: S3 bucket with policies and security
  - `cloudfront`: CDN distribution with OAI integration
- **State Management**: Local state (can be enhanced with remote state)

### Ansible Automation
- **Purpose**: Content deployment and synchronization
- **Configuration**:
  - Local execution (no remote hosts)
  - Uses `amazon.aws` collection for S3 operations
  - Syncs local `site/` directory to S3 bucket

## Data Flow

1. **Content Upload**: Ansible syncs static files to private S3 bucket
2. **User Request**: User accesses website via CloudFront URL
3. **CloudFront Processing**:
   - Checks cache for content
   - If miss, requests from S3 using OAI
4. **S3 Response**: Returns content to CloudFront via secure OAI access
5. **Content Delivery**: CloudFront serves content to user with HTTPS

## Security Considerations

- **S3 Privacy**: Bucket is completely private, no direct public access
- **HTTPS Only**: All traffic redirected to HTTPS
- **OAI Security**: CloudFront uses IAM-like access to S3
- **Encryption**: Server-side encryption on S3 objects

## Multi-Environment Support

The architecture supports multiple environments through Terraform variables:
- Environment-specific bucket names
- Tagged resources for cost tracking
- Isolated deployments per environment

## Scalability

- **CloudFront**: Global CDN with edge locations worldwide
- **S3**: Virtually unlimited storage and bandwidth
- **No Compute**: Static content requires no servers or containers