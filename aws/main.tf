
resource "aws_key_pair" "example" {
  public_key = file("${var.ssh_key_path}.pub")
}

resource "aws_vpc" "example" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-test-vpc"
  }
}

resource "aws_subnet" "example" {
  availability_zone       = var.zone
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-test-subnet"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "tf-test-internet-gateway"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "tf-test-route-table"
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "tf-test-security-group"
  }
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id

  security_groups = [aws_security_group.example.id]

  tags = {
    Name = "tf-test-network-interface"
  }
}

resource "aws_instance" "example" {
  availability_zone = var.zone
  ami               = var.image
  instance_type     = "t3.micro" # 2C1G

  key_name = aws_key_pair.example.id

  root_block_device {
    volume_size = 10
    tags = {
      Name = "tf-test-volume"
    }
  }

  network_interface {
    network_interface_id = aws_network_interface.example.id
    device_index         = 0
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_key_path)
    host        = self.public_ip
    timeout     = "3m"
  }

  provisioner "file" {
    source      = "../deploy_env.sh"
    destination = "/tmp/deploy_env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "echo remote-exec begin...",
      "TOKEN=$(curl -s -X PUT -H \"X-aws-ec2-metadata-token-ttl-seconds: 300\" \"http://169.254.169.254/latest/api/token\")",
      "local_ip=$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" \"http://169.254.169.254/latest/meta-data/local-ipv4\")",
      "echo Private IP: $local_ip",
      "public_ip=$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" \"http://169.254.169.254/latest/meta-data/public-ipv4\")",
      "echo Public IP: $public_ip",
      "bash /tmp/deploy_env.sh",
      "echo remote-exec end...",
    ]
  }

  tags = {
    Name = "tf-test-vm"
  }
}
