resource "aws_route53domains_registered_domain" "domain" {
  domain_name = var.domain_name

  auto_renew = var.domain_auto_renew
  tags = local.tags
}
