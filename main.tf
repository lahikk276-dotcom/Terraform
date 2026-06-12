provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/20"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
   Name = "my_vpc"
}
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
   Name = "my_igw"
}
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
   Name = "my_pubsub"
}
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
   Name = "privsub"
}
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
 resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public.id
   depends_on = [
      aws_internet_gateway.igw
   ]
 }
 resource "aws_route_table" "public_rt" {
     vpc_id = aws_vpc.main.id
     route  { 
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.igw.id
     }
   }
resource "aws_route_table" "private_rt" {
     vpc_id = aws_vpc.main.id
     route  {
       cidr_block = "0.0.0.0/0"
       nat_gateway_id = aws_nat_gateway.ngw.id
     }
   }
resource "aws_route_table_association" "public_assoc1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
 
     
