# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "AKIAJMROY3R7O3JBGXNA"
  secret_key = "IB0q5BC5lAx+ERKRoCAM1O2bwPWflBtywU+jDjnc"
  region = "us-east-2"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2

resource "aws_instance" "example" {
  ami = "ami-09558250a3419e7d0"
  instance_type = "t2.micro"
  count = 4
  tags = {Name = "Udacity T2"}
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4

resource "aws_instance" "example2" {
  ami = "ami-09558250a3419e7d0"
  instance_type = "m4.large"
  count = 2
  tags = {Name = "Udacity M4"}
}