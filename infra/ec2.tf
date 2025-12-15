# ============================================
# Get Latest Amazon Linux 2 AMI
# ============================================

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ============================================
# EC2 Key Pair (Optional - for SSH access)
# ============================================

# Generate SSH key using tls_private_key
resource "tls_private_key" "deployer" {
  count     = var.enable_eks ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  count      = var.enable_eks ? 0 : 1
  key_name   = "${var.project_name}-deployer-key"
  public_key = tls_private_key.deployer[0].public_key_openssh

  tags = {
    Name = "${var.project_name}-deployer-key"
  }
}

# Save private key locally (for SSH access)
resource "local_file" "private_key" {
  count           = var.enable_eks ? 0 : 1
  content         = tls_private_key.deployer[0].private_key_pem
  filename        = "${path.module}/deployer-key.pem"
  file_permission = "0600"
}

# ============================================
# EC2 Instance (Fallback if EKS is disabled)
# ============================================

resource "aws_instance" "app_server" {
  count         = var.enable_eks ? 0 : var.ec2_instance_count
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.ec2_instance_type

  subnet_id                   = aws_subnet.public[count.index % length(aws_subnet.public)].id
  vpc_security_group_ids      = [aws_security_group.ec2_instance.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              
              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              # Install Python 3
              yum install -y python3 python3-pip git
              EOF

  tags = {
    Name = "${var.project_name}-app-server-${count.index + 1}"
  }
}

# ============================================
# Elastic IP for EC2 Instances
# ============================================

resource "aws_eip" "app_server" {
  count    = var.enable_eks ? 0 : var.ec2_instance_count  # Changed from 2 to var.ec2_instance_count
  instance = aws_instance.app_server[count.index].id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-app-eip-${count.index + 1}"
  }
}
