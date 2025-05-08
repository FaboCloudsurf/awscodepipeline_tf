#subnet 1
resource "aws_subnet" "catpipeline_sn_app_A_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.32.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn_app_A1"
  }
}

#subnet 2
resource "aws_subnet" "catpipeline_sn_app_B_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.96.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_app_B1"
  }
}

#subnet 3
resource "aws_subnet" "catpipeline_sn_app_C_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.160.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_app_C1"
  }
}

#subnet 4
resource "aws_subnet" "catpipeline_sn_db_A_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.16.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_db_A1"
  }
}

#subnet 5
resource "aws_subnet" "catpipeline_sn_db_B_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.80.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_db_B1"
  }
}

#subnet 6
resource "aws_subnet" "catpipeline_sn_db_C_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.144.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_db_C1"
  }
}

#subnet 7
resource "aws_subnet" "catpipeline_sn_reserved_A_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn_reserved_A1"
  }
}

#subnet 8
resource "aws_subnet" "catpipeline_sn_reserved_B_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.64.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_reserved_B1"
  }
}

#subnet 9
resource "aws_subnet" "catpipeline_sn_reserved_C_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.128.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_reserved_C1"
  }
}

#subnet 10
resource "aws_subnet" "catpipeline_sn_web_A_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.48.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_web_A1"
  }
}

#subnet 11
resource "aws_subnet" "catpipeline_sn_web_B_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.112.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_web_B1"
  }
}

#subnet 12
resource "aws_subnet" "catpipeline_sn_web_C_tf1" {
  vpc_id            = aws_vpc.catpipeline_a4l_vpc_tf1.id
  cidr_block        = "10.16.176.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "sn_web_C1"
  }
}