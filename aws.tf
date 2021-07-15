terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_key_pair" "id_rsa_pub" {
  key_name   = "id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzOficFy1rzFvAIo8nIkjjKuLtr0qQawgYxdDslw/VOSv4WQ4f+hwtHzwEYSAZznS54geEifZeyUPs5QDvhtYHgVjCkQvFNVv8b4Gdi+bqgsyEJXJeDcJ4qbo9o4AES5GcYadyPBO5HIXoH04DUEAq8NgGbe/bo4rtj2dFu27X3/MZ2/yBKAav7dOLxArfdobQOOxrtpL4fcLkOpfNyvMI50gH7NKEFma2obI6TJKZw00EeBk6PykTuTB1mclQqYDQ3yUNlu10ggMDan6AiRcP1Y0sy+GlKtgW83VKqJHkWnxw0puPhtW6ENkHo0EHk2KaozZ3t9VsveQw8vPHNKRAisRzjcYtVzd1CvUULc/o5ZqxecO5hMwPrb0AWwB2iS1uH8tNGEvxKkGlhKEtHS3jXgnF4yBvPtw5CGqy/IksvNlGd1A8PrmdARmjG3vyMV7GDPtK+N+d9KsGrAyNjLyoyjv0ezRhFyuxq6D0QcEIoVZs+OJWUEFTWC9+4ZpBQA0= root@finalwork"
}

resource "aws_instance" "build" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.nano"
  key_name = "id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.build_allow_ssh.id}"]
  tags = {
    Name = "BuildInstance"
  }
}

resource "aws_instance" "prod" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.nano"
  key_name = "id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.prod_allow_ssh_web.id}"]
  tags = {
    Name = "ProdInstance"
  }
}

resource "aws_security_group" "build_allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH inbound traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prod_allow_ssh_web" {
  name = "allow_ssh_prod"
  description = "Allow SSH and Web inbound traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

