output "db_hostname" {
    value = "${aws_db_instance.ivcr_dbs.address}"
}
