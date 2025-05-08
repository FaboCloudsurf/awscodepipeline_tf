resource "aws_default_route_table" "catpipeline_A4L_vpc_drt_tf1" {
  default_route_table_id = aws_vpc.catpipeline_a4l_vpc_tf1.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.catpipeline_A4L_vpc_gw_tf1.id
  }
}


resource "aws_route_table" "catpipeline_A4L_vpc_rt_web1" {
  vpc_id = aws_vpc.catpipeline_a4l_vpc_tf1.id

 
  tags = {
    Name = "catpipeline_A4L-vpc-rt-web1"
  }
}

resource "aws_route_table_association" "RouteTableAssociationWebA1" {
  subnet_id      = aws_subnet.catpipeline_sn_web_A_tf1.id
  route_table_id = aws_route_table.catpipeline_A4L_vpc_rt_web1.id
}

resource "aws_route_table_association" "RouteTableAssociationWebB1" {
  subnet_id      = aws_subnet.catpipeline_sn_web_B_tf1.id
  route_table_id = aws_route_table.catpipeline_A4L_vpc_rt_web1.id
}

resource "aws_route_table_association" "RouteTableAssociationWebC" {
  subnet_id      = aws_subnet.catpipeline_sn_web_C_tf1.id
  route_table_id = aws_route_table.catpipeline_A4L_vpc_rt_web1.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.catpipeline_A4L_vpc_rt_web1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.catpipeline_A4L_vpc_gw_tf1.id
}
