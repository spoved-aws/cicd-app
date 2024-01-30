resource "aws_db_instance" "vprofile_db_mysql" {
  identifier                            = var.db_identifier
  allocated_storage                     = var.allocated_storage
  storage_type                          = var.storage_type
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  db_name                               = var.db_name
  username                              = var.username
  password                              = var.password
  parameter_group_name                  = var.parameter_group_name
  db_subnet_group_name                  = var.db_subnet_group_name
  vpc_security_group_ids                = [aws_security_group.allow_bs_traffic_sg.id]
  skip_final_snapshot                   = var.skip_final_snapshot
  backup_retention_period               = var.backup_retention_period
  maintenance_window                    = var.maintenance_window
  backup_window                         = var.backup_window
  multi_az                              = var.multi_az
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  port                                  = var.port
  publicly_accessible                   = var.publicly_accessible
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  delete_automated_backups              = var.delete_automated_backups
}
