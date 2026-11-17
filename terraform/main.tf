
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "cynbit_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Cynbit-VPC"
    Environment = "DevOps-Audit"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cynbit_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Cynbit-Public-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cynbit_vpc.id

  tags = {
    Name = "Cynbit-Internet-Gateway"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cynbit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Cynbit-Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "cynbit-web-security-group"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.cynbit_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Cynbit-Web-SG"
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo "Cynbit DevOps Infrastructure is Running" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  EOF

  tags = {
    Name        = "Cynbit-Web-Server"
    Environment = "DevOps-Audit"
  }
}
