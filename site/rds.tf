###################################################################
## RDS MySQL Instance
###################################################################
# https://github.com/terraform-aws-modules/terraform-aws-rds
locals {
  db_instance_name = "${var.prefix}-wp-mysql"

  #### SHARED ####
  db_username          = module.db.db_instance_username
  db_password          = random_password.master.result
  db_name              = module.db.db_instance_name
  db_connection_string = module.db.db_instance_endpoint
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  identifier = "${var.prefix}-${var.env}-db"

  engine                    = var.rds_engine
  major_engine_version      = var.rds_engine_major_version
  create_db_parameter_group = "false"
  create_db_option_group    = "false"
  skip_final_snapshot       = "true"

  instance_class        = var.rds_instance_class
  allocated_storage     = 5
  max_allocated_storage = 10

  username = "admin"
  db_name  = var.db_name
  password = random_password.master.result

  db_subnet_group_name   = local.db_subnet_group_name
  multi_az               = "true"
  subnet_ids             = local.db_subnet_ids
  vpc_security_group_ids = [local.db_security_group_id]
  tags                   = var.tags
}


################################################################################
# Supporting Resources
################################################################################

resource "random_password" "master" {
  length = 10
}

data "aws_rds_engine_version" "version" {
  engine  = "mariadb"
  version = "10.11.6"
}
