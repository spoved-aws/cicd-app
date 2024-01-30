variable "db_identifier" {
  description = "db_identifier" #db identifier name
  default     = "vprofile-mysql-db"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default     = 20
}

variable "storage_type" {
  description = "The type of storage"
  default     = "gp2"
}

variable "engine" {
  description = "The database engine to use"
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  default     = "5.7.37"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "The name of the database to create"
  default     = "accounts"
}

variable "username" {
  description = "Username for the master DB user"
  default     = "admin"
}

variable "password" {
  description = "Password for the master DB user"
  type        = string
  default     = "dbpass12345667"
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate"
  default     = "default.mysql5.7"
}

variable "db_subnet_group_name" {
  description = "The DB subnet group name"
  default     = "default-vpc-0ef3523f6b396969f"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  default     = 1
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  default     = "thu:06:30-thu:07:00"
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  default     = "03:26-03:56"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "port" {
  description = "The port on which the DB accepts connections"
  default     = 3306
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot"
  default     = true
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  default     = true
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = ["us-east-1f"]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}
