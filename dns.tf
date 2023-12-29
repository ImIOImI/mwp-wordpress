data "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "www_alb_cname_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [module.alb.lb_dns_name]
}

resource "aws_route53_record" "alb_cname_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = "60"
  records = [module.alb.lb_dns_name]
}
