resource "aws_vpc" "hsa_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "hsa"
  }
}

resource "aws_subnet" "hsa_subnet_1" {
  vpc_id                  = aws_vpc.hsa_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "hsa"
  }
}

resource "aws_subnet" "hsa_subnet_2" {
  vpc_id                  = aws_vpc.hsa_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "hsa"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.hsa_vpc.id

  tags = {
    Name = "hsa"
  }
}

resource "aws_route_table" "hsa_route_table" {
  vpc_id = aws_vpc.hsa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "hsa"
  }
}

resource "aws_route_table_association" "hsa_subnet_1_association" {
  subnet_id      = aws_subnet.hsa_subnet_1.id
  route_table_id = aws_route_table.hsa_route_table.id
}

resource "aws_route_table_association" "hsa_subnet_2_association" {
  subnet_id      = aws_subnet.hsa_subnet_2.id
  route_table_id = aws_route_table.hsa_route_table.id
}

resource "aws_security_group" "hsa_sg" {
  vpc_id = aws_vpc.hsa_vpc.id
  name   = "hsa-security-group"

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hsa"
  }
}