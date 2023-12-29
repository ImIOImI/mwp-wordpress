####################################################################
# EFS for FS sharing
####################################################################
resource "aws_efs_file_system" "efs" {
  creation_token = "${var.prefix}-${var.env}-efs"
  tags = var.tags
}

resource "aws_efs_mount_target" "efs_target" {
  for_each        = aws_subnet.private
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private[each.key].id
  security_groups = [module.efs_sg.security_group_id]
}
