#   module "rds_sg" {
#     source  = "terraform-aws-modules/security-group/aws"
#   version = "5.1.0"
  
#   #name = "private-sg"
#   name = var.rds_sg_name  
#   description = "Security Group with 3306 Open from SG of beanstalk app"
#   vpc_id = "vpc-0ef3523f6b396969f"
#   # Ingress Rules & CIDR Blocks
#   #ingress_rules = ["ssh-tcp", "http-80-tcp"]
#   ingress_with_source_security_group_id = [
#     {
#       rule                     = "http-80-tcp"
#       source_security_group_id = "sgsggsggsggs"
#     }
#   ]

#   ingress_cidr_blocks = ["172.31.0.0/16"]
#   # Egress Rule - all-all open
#   egress_rules = ["all-all"]
# }

resource "aws_security_group" "allow_bs_traffic_sg" {
  name        = var.rds_sg_name
  description = "Security group allowing traffic from port 3306 of beanstalk SG"
  vpc_id      = "vpc-0ef3523f6b396969f"

  // Ingress rule allowing traffic from an existing security group on port 3306
  ingress     = [
        {
            from_port        = 3306
            cidr_blocks      = ["172.31.0.0/16"]
            description      = "3306 of vprofile beanstalk SG"
            protocol         = "tcp"
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            self             = false
            security_groups  = data.aws_instance.first_instance.vpc_security_group_ids
            to_port          = 3306
        },
        {
            from_port        = 3306
            cidr_blocks      = ["172.31.0.0/16"]
            description      = "3306 of vprofile beanstalk SG"
            protocol         = "tcp"
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            self             = false
            security_groups  = data.aws_instance.first_instance.vpc_security_group_ids
            to_port          = 3306
        },
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}