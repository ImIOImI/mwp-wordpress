#####################################################################
# CloudWatch Autoscale Metric
#####################################################################
resource "aws_cloudwatch_metric_alarm" "scale-up-cpu-alarm" {
  alarm_name          = "scale-up-cpu-alarm"
  alarm_description   = "CPU Alarm for ASG up scaling"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = local.asg_autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [local.asg_autoscaling_policy_arns_scale_up]
  tags            = var.tags
}


resource "aws_cloudwatch_metric_alarm" "scale-down-cpu-alarm" {
  alarm_name          = "scale-down-cpu-alarm"
  alarm_description   = "CPU Alarm for ASG down scaling"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = local.asg_autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [local.asg_autoscaling_policy_arns_scale_down]
  tags            = var.tags
}
