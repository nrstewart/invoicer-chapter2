resource "aws_security_group_rule" "port_5432" {
    type                     = "ingress"
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    source_security_group_id = "${data.aws_security_group.ebs_instance.id}"
    security_group_id        = "${var.db_security_group}"
}
