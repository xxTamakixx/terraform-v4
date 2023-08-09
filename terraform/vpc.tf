################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"
  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
  intra_subnets   = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

## Security group 
# Public
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP access."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP access."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # cidr_blocks = ["${var.my_ip_adress}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Tier" = "public"
  }
}

# Private
resource "aws_security_group" "internal" {
  name        = "allow_internal"
  description = "Allow internal access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow internal access."
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_http.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Tire" = "private"
  }
}