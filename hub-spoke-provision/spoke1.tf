#Create VPC for SPOKE1
resource "aws_vpc" "spoke1_vpc" {
    cidr_block = "10.1.0.0/16"
    tags       = {
        Name = "spoke1-vpc"
    }
}

#Create IGW for SPOKE1
resource "aws_internet_gateway" "spoke1_igw" {
   vpc_id = aws_vpc.spoke1_vpc.id
   tags   = {
        Name ="spoke1-igw"
   }
}

#Create public subnet for spoke1
resource "aws_subnet" "spoke1_subnet" {
    vpc_id = aws_vpc.spoke1_vpc.id
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-2a"
    tags = {
        Name = "spoke1_subnet"
    }
}

#Create EC2-instance for spoke1
resource "aws_instance" "Nginx1" {
  ami           = "ami-0574e2e1fb193f719"
  key_name      = "tenet-test-nginx-key"
  instance_type = "t2.micro"
associate_public_ip_address = "true"
  subnet_id = aws_subnet.spoke1_subnet.id
  security_groups = ["${aws_security_group.spoke1_sg.id}"]
 tags       = {
        Name = "spoke1-instance"
    }
}

#Create security group for spoke1
resource "aws_security_group" "spoke1_sg" {
    vpc_id = aws_vpc.spoke1_vpc.id

    ingress {
        from_port = 80
        to_port = 80
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
        Name = "spoke1-sg"
    }
}
