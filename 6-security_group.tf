resource "aws_security_group" "catpipeline_sg_tf1" {
  name        = "catpipeline_security_group1"
  description = "Enable SSH access via port 22 IPv4 & v6"
  vpc_id      = aws_vpc.catpipeline_a4l_vpc_tf1.id
  
  tags = {
    Name = "catpipeline_sg1"
  }
    ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

ingress {
    description = "HTTP from my IP"
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
}


# resource "aws_vpc_security_group_ingress_rule" "catpipeline_sg_tf_ipv4" {
#   security_group_id = aws_security_group.catpipeline_sg_tf1.id
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
#   cidr_ipv4         = "0.0.0.0/0" 
 
# }

# resource "aws_vpc_security_group_ingress_rule" "catpipeline_sg_tf_ipv6" {
#   security_group_id = aws_security_group.catpipeline_sg_tf1.id
  
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
#   cidr_ipv4         = "0.0.0.0/0" 

# }

# resource "aws_vpc_security_group_egress_rule" "catpipeline_allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.catpipeline_sg_tf1.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

resource "aws_vpc_security_group_egress_rule" "catpipeline_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.catpipeline_sg_tf1.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

