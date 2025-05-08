output "instance_ip" {
  value = aws_instance.catpipeline_A4L-PublicEC2_tf1.public_ip
}

output "user_data_script" {
  value = base64encode(file("${path.module}/user_data.sh"))
}
