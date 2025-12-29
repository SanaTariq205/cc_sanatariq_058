variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the Subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for resources"
  type        = string
  default     = "us-east-1a"
}

variable "env_prefix" {
  description = "Environment prefix for tagging"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "public_key" {
  description = "Path to the public key file or the key itself"
  type        = string
}

variable "private_key" {
  description = "Path to the private key file (for display/output purposes)"
  type        = string
}

variable "backend_servers" {
  description = "List of backend servers to deploy"
  type = list(object({
    name        = string
    suffix      = string
    script_path = string
  }))
  default = []
}
