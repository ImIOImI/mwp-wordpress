locals {
  private_azs = slice(data.aws_availability_zones.this.names, 0, length(var.private_subnet_cidrs))
  region = "us-east-1"

  tags = {
    app = "wordpress"
    env = var.env
  }
}

output "private_azs" {
  value = local.private_azs
}
