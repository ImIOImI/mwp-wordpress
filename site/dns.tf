data "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "www_alb_cname_record" {
  count   = var.enable_route53 == true ? 1 : 0
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [local.alb_dns_name]
}

resource "aws_route53_record" "www" {
  count   = var.enable_route53 == true ? 1 : 0
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = local.alb_dns_name
    zone_id                = local.alb_zone_id
    evaluate_target_health = true
  }
}
