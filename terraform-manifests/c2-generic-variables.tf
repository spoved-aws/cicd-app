# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "stage"
}
# Business Division
variable "app" {
  description = "vprofile-app"
  type = string
  default = "vprofile-java-app"
}

variable "aws_account_number" {
  description = "aws account# for this project"
  type = number
  default = 477864231468
}

