####################################################################
# ELB
####################################################################
# https://github.com/terraform-aws-modules/terraform-aws-alb
locals {
  alb_dns_name = module.alb.lb_dns_name
  alb_zone_id  = module.alb.lb_zone_id
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.10.0"

  name               = "${var.prefix}-${var.env}-alb"
  load_balancer_type = "application"
  vpc_id             = local.vpc_id
  subnets            = local.public_subnet_ids
  security_groups    = [module.http_sg.security_group_id]
  internal           = false

  http_tcp_listeners = [
    {
      port               = "80"
      protocol           = "HTTP"
      action_type        = "redirect"
      target_group_index = 0
      redirect           = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = aws_acm_certificate.cert.arn
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "h1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check     = {
        enabled             = true
        interval            = 120
        path                = "/"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 20
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  tags = var.tags

  depends_on = [
    local.public_subnet_ids,
  ]
}
