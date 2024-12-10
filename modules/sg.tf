### Security Group
resource "aws_security_group" "security_groups" {
  for_each = {
    batch_env = { name = "${var.project}-batch-env-sg" }
  }

  name        = each.value.name
  description = each.value.name
  vpc_id      = var.vpc_id

  tags = {
    Name = each.value.name
  }
}

### Security Group Rule
resource "aws_security_group_rule" "security_group_rules" {
  depends_on = [aws_security_group.security_groups]
  for_each = {
    to_internet = {
      type                     = "egress",
      port                     = 0,
      protocol                 = "-1",
      description              = "to internet",
      source_security_group_id = null,
      cidr_blocks              = ["0.0.0.0/0"],
      self                     = null
    }
  }

  type                     = each.value.type
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = each.value.protocol
  description              = each.value.description
  security_group_id        = aws_security_group.security_groups["batch_env"].id
  source_security_group_id = each.value.source_security_group_id
  cidr_blocks              = each.value.cidr_blocks
  self                     = each.value.self
}
