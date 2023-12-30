locals {
  db_subnet_ids        = module.vpc.database_subnets
  db_subnet_group_name = module.vpc.database_subnet_group_name
  private_subnet_ids   = module.vpc.private_subnets
  public_subnet_ids    = module.vpc.public_subnets
  vpc_id               = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name                         = "${var.prefix}-${var.env}-vpc"
  cidr                         = var.vpc_cidr
  azs                          = data.aws_availability_zones.this.names
  create_database_subnet_group = "true"
  public_subnets               = var.public_subnet_cidrs
  private_subnets              = var.private_subnet_cidrs
  database_subnets             = var.database_subnet_cidrs
  enable_dns_hostnames         = "true"
  manage_default_vpc           = true

  tags = local.tags
}
