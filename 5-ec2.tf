

resource "aws_instance" "catpipeline_A4L-PublicEC2_tf1" {
  ami                     = var.ami
  instance_type           = "t2.micro"
  disable_api_termination = false
  key_name                = data.aws_key_pair.consolecatpipeline_tf1.key_name  # Reference the key pair
  subnet_id               = aws_subnet.catpipeline_sn_web_A_tf1.id
  iam_instance_profile    = aws_iam_instance_profile.catpipeline_A4L_ec2_profile_tf1.name
  vpc_security_group_ids  = [aws_security_group.catpipeline_sg_tf1.id]
  # user_data = <<EOF
  #         #!/bin/bash -xe
  #         yum update -y
  #         yum install wget git -y
  #         amazon-linux-extras install docker -y
  #         service docker start
  #         usermod -a -G docker ec2-user
  #             EOF
  #user_data = file("user_data.sh") # Reference the user data script
  #user_data = ("${path.module}/user_data.sh")
  user_data_base64 = base64encode(file("${path.module}/user_data.sh"))
  tags = {
    Name = "cat_A4L-PublicEC21"


 
  }


}
  

# resource "aws_key_pair" "catpipeline_key_tf1" {
#   key_name   = "cat_pipeline_key"
#   public_key = file("/Users/home/.ssh/cat_pipeline_key.pub")
#   }

   data "aws_key_pair" "consolecatpipeline_tf1" {
     key_name = "consolecatpipeline"  # Use the name of the key pair you created
   }

 