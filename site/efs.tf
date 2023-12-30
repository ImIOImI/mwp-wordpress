####################################################################
# EFS for FS sharing
####################################################################
locals {
  #### SHARED ####
  efs_dns_name = aws_efs_file_system.efs.dns_name
}
resource "aws_efs_file_system" "efs" {
  creation_token = "${var.prefix}-${var.env}-efs"
  tags           = var.tags
}

resource "aws_efs_mount_target" "efs_target" {
  count           = length(local.private_subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = local.private_subnet_ids[count.index]
  security_groups = [local.efs_security_group_id]
}
