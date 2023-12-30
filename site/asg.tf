####################################################################
# AutoScaling Group
####################################################################
locals {
  #### SHARED ####
  asg_autoscaling_policy_arns_scale_up   = module.asg.autoscaling_policy_arns.scale-up
  asg_autoscaling_policy_arns_scale_down = module.asg.autoscaling_policy_arns.scale-down
  asg_autoscaling_group_name             = module.asg.autoscaling_group_name
}
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.3.0"

  name                      = "${var.prefix}-${var.env}-asg"
  instance_name             = "${var.prefix}-${var.env}-web"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = local.public_subnet_ids

  # Launch Template
  launch_template_name        = "${var.prefix}-${var.env}-lt"
  launch_template_description = var.asg_launch_template_description
  update_default_version      = true
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = var.asg_instance_type
  target_group_arns           = local.alb_target_group_arns
  key_name                    = var.ssh_key_name
  user_data                   = base64encode(templatefile("${path.module}/wordpress-init.sh",
    {
      vars = {
        efs_dns_name = local.efs_dns_name
        DB_NAME      = local.db_name
        DB_USERNAME  = local.db_username
        DB_PASSWORD  = local.db_password
        DB_HOST      = local.db_connection_string
      }
    }))
  tag_specifications = [
    {
      resource_type = "instance"
      tags          = var.tags
    }
  ]

  network_interfaces = [
    {
      delete_on_termination       = true
      description                 = "eth0"
      device_index                = 0
      security_groups             = [local.ssh_security_group_id]
      associate_public_ip_address = true
    }
  ]

  scaling_policies = {
    scale-up = {
      policy_type        = "SimpleScaling"
      name               = "${var.prefix}-${var.env}-cpu-scale-up"
      scaling_adjustment = 1
      adjustment_type    = "ChangeInCapacity"
      cooldown           = "500"
    },
    scale-down = {
      policy_type        = "SimpleScaling"
      name               = "${var.prefix}-${var.env}-cpu-scale-down"
      scaling_adjustment = "-1"
      adjustment_type    = "ChangeInCapacity"
      cooldown           = "500"
    }
  }

  tags = var.tags

  depends_on = [aws_efs_mount_target.efs_target]
}

## Delay to allow time to initialize EC2
resource "time_sleep" "wait_180_seconds" {
  create_duration = "180s"
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.key.public_key_openssh
}
