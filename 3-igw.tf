resource "aws_internet_gateway" "catpipeline_A4L_vpc_gw_tf1" {
  vpc_id = aws_vpc.catpipeline_a4l_vpc_tf1.id

  tags = {
    Name = "catpipeline_A4L_vpc_igw1"
  }
}