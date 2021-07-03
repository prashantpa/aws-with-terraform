provider "aws" {
  region = "us-west-2"
}

# VPC Creation 

resource "aws_vpc" "myvpc" {
  cidr_block       = "${var.my_vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

# Query all avilable Availibility Zone

data "aws_availability_zones" "available" {}

# create internet gateway 

resource "aws_internet_gateway" "mygw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "mygw"
  }
}

# Public Route Table

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mygw.id}"
  }

  tags = {
    Name = "public route table"
  }
}

resource "aws_default_route_table" "Priavte_route" {
  default_route_table_id = "${aws_vpc.myvpc.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.mynatgw.id}"
  }

  tags = {
    Name = "private route table"
  }
}

# create public subnet

resource "aws_subnet" "public_subnet" {
  count = 2   
  cidr_block = "${var.public_cidrs[count.index]}"
  vpc_id     = "${aws_vpc.myvpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  
  tags = {
    Name = "public-subnet.${count.index + 1}"
  }
}

# Create priavte subnet

resource "aws_subnet" "private_subnet" {
  count = 2  
  cidr_block = "${var.private_cidrs[count.index]}"
  vpc_id     = "${aws_vpc.myvpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  
  tags = {
    Name = "private-subnet.${count.index + 1}"
  }
}





