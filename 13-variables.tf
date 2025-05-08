variable "aws_region" {
  description = "The AWS region to deploy the resources."
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "The AWS account ID."
  type        = string
}

variable "ami" {
  description = "The id for AWS ec2 instances."
  type        = string
  default     = "ami-07a6f770277670015"
}

variable "iam_role" {
  description = "The IAM role to be used by the EC2 instances."
  type        = string
  default     = "catpipeline_build_service_role1"
}

variable "environment" {
  description = "Deployment environment (stage,dev or prod)"
  type        = string
}

variable "source_repository" {
  description = "URL of the source code repository"
  type        = string
  default     = "https://github.com/FaboCloudsurf/catpipeline41125.git"
}

variable "git_hub_token" {
  description = "GitHub token for authentication"
  type        = string
  
}

variable "git_hub_repository" {
  description = "GitHub repository name"
  type        = string
  default     = "catpipeline41125"
}

variable "git_hub_repository_url" {
  description = "GitHub repository name"
  type        = string
  default     = "https://github.com/FaboCloudsurf/catpipeline41125.git"
}

variable "default_security_group" {
  description = "Default security group for the VPC"
  type        = string
  
}