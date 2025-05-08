resource "aws_lb" "catpipeline_lb_tf1" {
  name               = "catpipelinelb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.catpipeline_sg_tf2.id]
  subnets            = [aws_subnet.public_a.id, 
                        aws_subnet.public_b.id, 
                        aws_subnet.public_c.id, 
                        aws_subnet.public_d.id, 
                        aws_subnet.public_e.id, 
                        aws_subnet.public_f.id]

  
  #ip_address_type     = "ipv4"

  #enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}



#Define the security group
resource "aws_security_group" "catpipeline_sg_tf2" {
  name        = "catpipeline_sg_2"
  description = "My catpipeline Security Group"
  vpc_id      = aws_default_vpc.default.id 

#   # Ingress rules (example: allowing SSH and HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Egress rules (example: allowing all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "catpipeline_sg2"
  }
}


resource "aws_default_vpc" "default" {

  tags = {
    Name = "Default VPC"
  }

  # Prevents the default VPC from being deleted
  # lifecycle {
  #   prevent_destroy = true
  # }
}
#import default vpc

#terraform import aws_default_vpc.default vpc-0b07fdd33868bcd22

# import {
#   to = aws_default_vpc.default            #should have been a data block instead
#   id = "vpc-0b07fdd33868bcd22"
# }

# resource "aws_default_vpc" "default" {
#     cidr_block                           = "172.31.0.0/16"
#     enable_dns_hostnames                 = true
#     enable_dns_support                   = true
#     instance_tenancy                     = "default"
#     lifecycle {
#     prevent_destroy = true

# } 

# }

#create one subnet per availability zone and map them to the load balancer
# resource "aws_subnet" "public" {
#   count                   = length(data.aws_availability_zones.available.names)
#   vpc_id                  = aws_default_vpc.default.id
#   cidr_block              = cidrsubnet(aws_default_vpc.default.cidr_block, 8, count.index)
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Public Subnet ${count.index + 1}"
#   }
# }


#The data "aws_availability_zones" "available" block in Terraform uses the AWS API to dynamically fetch all availability zones 
#that are currently available in the region where your Terraform provider is configured (us-east-1).

# data block: This tells Terraform to query AWS for information rather than creating anything.

# aws_availability_zones: This is the data source for getting AZ info.

# available_zones: This is just the local name for the data source (you can name it whatever you want).

# state = "available": This filters only AZs that are currently active and usable.

data "aws_availability_zones" "available_zones" {
  state = "available"
}


#this output block will print all the availability zones and their zone IDs from your data "aws_availability_zones" block

# output "availability_zone_names" {
#   value = data.aws_availability_zones.available.names
# }

# output "availability_zone_ids" {
#   value = data.aws_availability_zones.available.zone_ids
# }

#create subnets across all availability zones in the region
# resource "aws_subnet" "public" {
#   count = length(data.aws_availability_zones.available.names)

#   vpc_id                  = aws_default_vpc.default.id
#   cidr_block              = cidrsubnet(aws_default_vpc.default.cidr_block, 4, count.index)
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-${data.aws_availability_zones.available.names[count.index]}"
#   }
# }

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-c"
  }
}

resource "aws_subnet" "public_d" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.4.0/24"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-d"
  }
}

resource "aws_subnet" "public_e" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.5.0/24"
  availability_zone       = "us-east-1e"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-e"
  }
}

resource "aws_subnet" "public_f" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.6.0/24"
  availability_zone       = "us-east-1f"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-f"
  }
}


#create a target group for the load balancer

resource "aws_lb_target_group" "catpipelineA_tg_tf1" {
  name        = "catpipelineA-tg"
  port        = 80
  protocol    = "HTTP"
  protocol_version = "HTTP1"
  target_type = "ip"  #because this target group will be pointing at containers inside of the ECS fargate
  vpc_id      = aws_default_vpc.default.id
  ip_address_type = "ipv4"
  
}

resource "aws_lb_listener" "listener_tf1" {
  load_balancer_arn = aws_lb.catpipeline_lb_tf1.arn
  port              = "80"  #anything hitting port 80 is going to be directed to the target group
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catpipelineA_tg_tf1.arn
  }
}

#vpc = default
#subnets = public_a, public_b, public_c, public_d, public_e, public_f
#security_groups = catpipeline_sg_tf2

