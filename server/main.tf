// create VPC, subnets, security groups, and EC2 instances ( 1 ubuntu and 1 windows ) for the system engineer foundation project

// server 1 - ubuntu :  ami-01f79b1e4a5c64257, t3.micro

resource "aws_instance" "ubuntu" {
  ami           = "ami-01f79b1e4a5c64257"
  instance_type = "t3.micro"

  tags = {
    Name = "mb-01-ubuntu"
  }
}

// server 2 -  windows : ami-0e3af9e89c78d4b08

resource "aws_instance" "windows" {
  ami           = "ami-0e3af9e89c78d4b08"
  instance_type = "t3.micro"

  tags = {
    Name = "mb-02-windows"
  }
}

create  2 servers: ubuntu  ami-01f79b1e4a5c64257 t3.micro and windows ami-0e3af9e89c78d4b08 t3.micro. 
configure openssh-22 for ubuntu and rdp-3389 and openssh-22 for windows.

 current network module:
 variable "environment" { type = string }
variable "name_prefix" { type = string }

data "aws_availability_zones" "available" {}

resource "aws_vpc" "app" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.name_prefix}-${var.environment}-vpc" }
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
  tags   = { Name = "${var.name_prefix}-${var.environment}-igw" }
}

resource "aws_subnet" "app_public" {
  vpc_id                  = aws_vpc.app.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name_prefix}-${var.environment}-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app.id
  tags   = { Name = "${var.name_prefix}-${var.environment}-public-rt" }
}

resource "aws_route" "default_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.app_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "app" {
  name   = "${var.name_prefix}-${var.environment}-sg"
  vpc_id = aws_vpc.app.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.app_public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device { encrypted = true }

  tags = { Name = "${var.name_prefix}-${var.environment}-app" }
}


 current compute module: 




