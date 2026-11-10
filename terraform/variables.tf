variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-west-1a"
}

variable "environment" {
  description = "Environment tag applied to resources"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t3.micro"
}