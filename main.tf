provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You can restrict this to your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k3s_node" {
  ami                    = "ami-03f4878755434977f" # Ubuntu 22.04 LTS for ap-south-1
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  provisioner "file" {
    source      = "install_k3s.sh"
    destination = "/tmp/install_k3s.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k3s.sh",
      "sudo /tmp/install_k3s.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "k3s-node"
  }
}

output "public_ip" {
  value = aws_instance.k3s_node.public_ip
}
