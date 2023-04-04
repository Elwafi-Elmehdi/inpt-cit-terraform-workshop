# HCL configuration goes here

##########################################
## Provider
##########################################

provider "aws" {
  region = "eu-west-3"
  shared_config_files = [ "./credentials" ]
}

##########################################
## Data Sources
##########################################

##########################################
## Resources
##########################################


resource "aws_security_group" "allow_http" {
  name        = "HTTP Access from public subnet"
  description = "HTTP Access from public subnet"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS Public Traffic"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  egress {
    description      = "Allow Egress Internet Access"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "webserver" {
  ami                    = "ami-017d9f576d1635a77"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data              = file("./setup.sh")
  tags = {
    "Name" = "Web Server"
  }
}
##########################################
## Outputs
##########################################
output "web_server_public_ip" {
    value = aws_instance.webserver.public_ip
}