//Terraform

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws"{
region= "us-east-1"
}
//creating our own vpc
resource "aws_vpc" "wordpress-vpc" {
  cidr_block       = "192.163.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "wordpress-vpc"
  }
}

//creating public subnet for wordpress
resource "aws_subnet" "wpsubnet" {
  vpc_id     = "${aws_vpc.wordpress-vpc.id}"
  cidr_block = "192.163.0.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name = "wpsubnet"
  }
}


//creating internet gateway
resource "aws_internet_gateway" "WPgw" { 
  vpc_id = "${aws_vpc.wordpress-vpc.id}"

  tags = {
    Name = "WPgw"
  }
}

//creating route table
resource "aws_route_table" "wproute" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.WPgw.id}"
 }


  tags = {
    Name = "wproute"
  }
}



//associating route table with wpsubnet
resource "aws_route_table_association" "sub1" {
  subnet_id      = aws_subnet.wpsubnet.id
  route_table_id = aws_route_table.wproute.id
}

//create secuirty group for wordpress for wpsubnet
resource "aws_security_group" "wpSG" {
  name = "wpSG"
  vpc_id = "${aws_vpc.wordpress-vpc.id}"
  ingress {
	description= "allow ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
 	description="allow http "
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }


 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags ={
   
    Name= "wpSG"
  }

}


//create wordpress instances
resource "aws_instance" "wordpress_instance" {
  ami           = ""
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.wpsubnet.id}"
  vpc_security_group_ids = ["${aws_security_group.wpSG.id}"]
  key_name = "key"
 tags ={
    
    Name= "wordpress_instance"
  }

}