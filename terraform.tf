provider "aws" {
  region = "eu-north-1"
  profile = "terraform"
}

resource "aws_instance" "teraform_ubuntu" {
  ami = "ami-092cce4a19b438926" # Ubuntu Server 20.04 LTS ami
  instance_type = "t3.micro"
  key_name = "pavlo-key-stockholm"
  tags = {
  "Name" = "terraform_ubuntu"
  }

  vpc_security_group_ids = [aws_security_group.teraform_ubuntu.id]

}
resource "aws_security_group" "teraform_ubuntu" {
  name        = "teraform_ubuntu"
  description = "Security policies for ubuntu instance"

    ingress {
    description      = "for TomCat"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

   ingress {
    description      = "SSH from host to EC2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

    ingress {
    description      = "PostgreSQL for DB"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

   ingress {
    description      = "SMTP for mail"
    from_port        = 25
    to_port          = 25
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_ubuntu"
  }
}

resource "aws_instance" "teraform_Postgres_DB" {
  ami   = "ami-013126576e995a769" # Amazon linux ami
  instance_type = "t3.micro"
  key_name = "pavlo-key-stockholm"
  tags  = {
   "Name" = "terraform_PostgreSQL_DB"
  }
  vpc_security_group_ids = [aws_security_group.teraform_PostgreSQL_DB.id]

}

resource "aws_security_group" "teraform_PostgreSQL_DB" {
  name        = "PostgreSQL_DB"
  description = "Security policies for PostgreSQL_DB instance"

   ingress {
    description      = "SSH from host to EC2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

    ingress {
    description      = "PostgreSQL for DB"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_PostgreSQL_DB"
  }
  }

  resource "local_file" "public_ip" {
    content = <<EOT
    [terraform_ubuntu]
    ${aws_instance.teraform_ubuntu.public_ip}
    [teraform_Postgres_DB]
    ${aws_instance.teraform_Postgres_DB.public_ip}
    EOT
      filename = "../ansible/hostsIP.txt"
    }

    resource "local_file" "public_ip_for_deploy" {
      content = <<EOT
      #!/bin/bash
      server_ip='${aws_instance.teraform_ubuntu.public_ip}';
      DB_ip='${aws_instance.teraform_Postgres_DB.public_ip}';
      EOT

        filename = "../ansible/roles/terraform_ubuntu/files/serversIP"
      }
