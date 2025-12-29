vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
availability_zone = "us-east-1a"
env_prefix        = "prod"
instance_type     = "t3.micro"
# Ideally these should point to real keys on your machine
public_key        = "~/.ssh/id_rsa.pub" 
private_key       = "~/.ssh/id_rsa"
