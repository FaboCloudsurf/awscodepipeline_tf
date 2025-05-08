resource "aws_vpc" "catpipeline_a4l_vpc_tf1" {
  cidr_block       = "10.16.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "a4l-vpc11"
  }
}