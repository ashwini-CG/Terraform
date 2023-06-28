terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0.1"
    }
  }
}


provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

#Create VPC for HUB
resource "aws_vpc" "hub_vpc" {
    cidr_block = "10.0.0.0/16"
    tags       = {
        Name = "hub-vpc"
    }
}

#Create IGW for HUB
resource "aws_internet_gateway" "hub_igw" {
   vpc_id = aws_vpc.hub_vpc.id
   tags   = {
        Name ="hub-igw"
   }
}

#Create public subnet for hub
resource "aws_subnet" "hub_subnet" {
    vpc_id = aws_vpc.hub_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-2a"
    tags = {
        Name = "hub_subnet"
    }
}

#Create EC2-instance for hub
resource "aws_instance" "Jenkins" {
  ami           = "ami-0da556794ee0c2d6e"
  key_name      = "tenet-test-key-jenkins"
  instance_type = "t2.micro"
 security_groups = ["${aws_security_group.hub_sg.id}"]
subnet_id = aws_subnet.hub_subnet.id
associate_public_ip_address = "true"
 tags       = {
        Name = "hub-instance"
    }

}


#Create security group for hub
resource "aws_security_group" "hub_sg" {
    vpc_id = aws_vpc.hub_vpc.id

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags       = {
        Name = "hub-SG"
    }
}
