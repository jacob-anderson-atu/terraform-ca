provider "aws" {
  region     = var.aws_region
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

# ------------------------------------------------------------
# VPC
# ------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "sentinel-test-vpc"
    Environment = var.environment
    managed_by  = "terraform"
  }
}

# ------------------------------------------------------------
# Subnets
# ------------------------------------------------------------

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "sentinel-test-subnet"
    Environment = var.environment
    managed_by  = "terraform"
  }
}

# ------------------------------------------------------------
# Security Group
# ------------------------------------------------------------

resource "aws_security_group" "web" {
  name        = "sentinel-web-sg"
  description = "Security group for Sentinel test"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sentinel-web-sg"
    Environment = var.environment
    managed_by  = "terraform"
  }
}

# ------------------------------------------------------------
# EC2 Instance 1
# ------------------------------------------------------------

resource "aws_instance" "web_01" {
  ami             = "ami-12345678" # LocalStack AMI ID for testing
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.web.id]

  # LocalStack has a bug where it does not support encrypted root volumes, so the following block is commented out. Uncomment it when using a real AWS environment.
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 10
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  tags = {
    Name        = "sentinel-web-01"
    Environment = var.environment
    managed_by  = "terraform"
  }
}

# ------------------------------------------------------------
# EC2 Instance 2
# ------------------------------------------------------------

resource "aws_instance" "web_02" {
  ami             = "ami-12345678" # LocalStack AMI ID for testing
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.web.id]

  # LocalStack has a bug where it does not support encrypted root volumes, so the following block is commented out. Uncomment it when using a real AWS environment.
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 10
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  tags = {
    Name        = "sentinel-web-02"
    Environment = var.environment
    managed_by  = "terraform"
  }
}

# ------------------------------------------------------------
# Additional encrypted EBS volume
# ------------------------------------------------------------

resource "aws_ebs_volume" "data" {
  availability_zone = "${var.aws_region}a"
  size              = 10
  encrypted         = true
  type              = "gp3"

  tags = {
    Name        = "sentinel-data-volume"
    Environment = var.environment
    managed_by  = "terraform"
  }
}   