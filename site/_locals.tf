locals {
  private_azs = slice(data.aws_availability_zones.this.names, 0, length(var.private_subnet_cidrs))
  region      = "us-east-1"

  tags = merge({
    app     = var.prefix
    env     = var.env
    managed = "terraform"
  }, var.additional-tags)
}

output "private_azs" {
  value = local.private_azs
}
