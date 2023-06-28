#Create VPC for SPOKE2
resource "aws_vpc" "spoke2_vpc" {
    cidr_block = "10.2.0.0/16"
    tags       = {
        Name = "spoke2-vpc"
    }
}

#Create IGW for SPOKE2
resource "aws_internet_gateway" "spoke2_igw" {
   vpc_id = aws_vpc.spoke2_vpc.id
   tags   = {
        Name ="spoke2-igw"
   }
}
#Create public subnet for spoke2
resource "aws_subnet" "spoke2_subnet" {
    vpc_id = aws_vpc.spoke2_vpc.id
    cidr_block = "10.2.1.0/24"
    availability_zone = "us-east-2a"
    tags = {
        Name = "spoke2_subnet"
    }
}

#Create EC2-instance for spoke1terraf
resource "aws_instance" "Nginx2" {
  ami           = "ami-0574e2e1fb193f719"
  key_name      = "tenet-test-nginx-key"
  instance_type = "t2.micro"
 security_groups =  ["${aws_security_group.spoke2_sg.id}"]
 subnet_id = aws_subnet.spoke2_subnet.id
 associate_public_ip_address = "true"
 tags       = {
        Name = "spoke2-instance"
    }
}

#Create security group for spoke1
resource "aws_security_group" "spoke2_sg" {
    vpc_id = aws_vpc.spoke2_vpc.id

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
        Name = "spoke2-sg"
    }
}
                  