provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "ec2" {
  key_name = var.key-name
  public_key = file("C:/Users/sadhu/my-key.pub")
}

resource "aws_security_group" "network-security-group" {
  name = var.network-security-group-name
  description = "ALLOW TLS Inbound Traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "prometheus"
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "alertmanager"
    from_port = 9093
    to_port = 9093
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "node exporter"
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "jenkins"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all traffic"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-inbound"
  }
}

variable "instance_names" {
  type = list
  default = ["grafana", "prometheus", "jenkins"]
}

resource "aws_instance" "myec2" {
  ami = var.ubuntu-ami
  instance_type = var.ubuntu-instance-type
  key_name = aws_key_pair.ec2.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  count = 3
  tags = {
    Name = var.instance_names[count.index]
  }
}