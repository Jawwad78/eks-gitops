resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eksvpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id     = aws_vpc.eks.id
  cidr_block = "10.0.${count.index + 1}.0/26"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id     = aws_vpc.eks.id
  cidr_block = "10.0.${count.index + 3}.0/26"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route-to-igw"
  }
}

resource "aws_route_table_association" "a" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.igw.id
}


resource "aws_eip" "lb" {
  domain   = "vpc"
}

# Using regional NAT to span across both AZ's!
resource "aws_nat_gateway" "example" {
  vpc_id            = aws_vpc.eks.id
  availability_mode = "regional"

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "nat-route"
  }
}

resource "aws_route_table_association" "b" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.nat.id
}