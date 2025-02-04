resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "${var.project_name}_vpc"
  }
}

data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "pub_sub_web_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_sub_web_1"
  }
}

resource "aws_subnet" "pub_sub_web_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_sub_web_2"
  }
}

resource "aws_subnet" "priv_sub_app_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "priv_sub_app_1"
  }
}

resource "aws_subnet" "priv_sub_app_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "priv_sub_app_2"
  }
}

resource "aws_subnet" "priv_sub_data_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "priv_sub_data_1"
  }
}

resource "aws_subnet" "priv_sub_data_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "priv_sub_data_2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}_igw"
  }
}

resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id = aws_subnet.pub_sub_web_1.id

  tags = {
    Name = "${var.project_name}-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id = aws_subnet.pub_sub_web_2.id

  tags = {
    Name = "${var.project_name}-nat-gw-2"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "pub_sub_assoc_web_1" {
  subnet_id      = aws_subnet.pub_sub_web_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "pub_sub_assoc_web_2" {
  subnet_id      = aws_subnet.pub_sub_web_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_app_route_table_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "private_app_route_table_1"
  }
}

resource "aws_route_table" "private_app_route_table_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "private_app_route_table_2"
  }
}

resource "aws_route_table_association" "private_sub_assoc_app_1" {
  subnet_id      = aws_subnet.priv_sub_app_1.id
  route_table_id = aws_route_table.private_app_route_table_1.id
}

resource "aws_route_table_association" "private_sub_assoc_app_2" {
  subnet_id      = aws_subnet.priv_sub_app_2.id
  route_table_id = aws_route_table.private_app_route_table_2.id
}