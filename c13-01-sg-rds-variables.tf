variable "rds_sg_name" {
  description = "sg name for rds"
  type        = string
  default     = "vprofile-rds-sg"
}

# variable "bs_sg_list" {
#   type = list(string)
#   default = [for s in aws_elastic_beanstalk_environment.tfenv.all_settings : s.value if s.name == "SecurityGroups" && s.value != ""]
# }