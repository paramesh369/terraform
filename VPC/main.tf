# To create a VPC network
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "App-vpc"
  }
}

# To create a subnets

resource "aws_subnet" "app-subnet-public1" {
  vpc_id = aws_vpc.app-vpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true # It will enable and assign the public ip.
  tags = {
    Name = "app-public-subnet1"
  }
}

resource "aws_subnet" "app-subnet-private1" {
  vpc_id = aws_vpc.app-vpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "app-private-subnet1"
  }
}

# To create and attach an Internet Gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.app-vpc.id 
  tags = {
    Name = "app-igw"
  }
}

/*
# This is an alternate way of attaching the igw to VPC. Befor enabling this comment the "vpc_id" in the above igw resource.
resource "aws_internet_gateway_attachment" "gateway-attachment" {
  internet_gateway_id = aws_internet_gateway.gateway.id
  vpc_id = aws_vpc.app-vpc.id
}
*/

# Create a public route table and add the igw in the routes to allow the traffic
resource "aws_route_table" "public-routetable" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "app-routetable-public"
  }
}

# Associate public subnet  for the public route table which has internete access
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id = aws_subnet.app-subnet-public1.id
  route_table_id = aws_route_table.public-routetable.id
}

# Create a private route table, which doesn't allow internet connectivity
resource "aws_route_table" "private-routetable" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "app-routetable-private"
  }
}

# Associate private subnet  for the private route table which doesn't have internete access
resource "aws_route_table_association" "private-subnet-association" {
  subnet_id = aws_subnet.app-subnet-private1.id
  route_table_id = aws_route_table.private-routetable.id
}
