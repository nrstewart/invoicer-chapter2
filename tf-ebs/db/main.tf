resource "aws_db_instance" "ivcr_dbs" {
    name                    = "invoicer"
    identifier              = "${var.identifier}"
    vpc_security_group_ids  = ["${var.db_security_group}"]
    allocated_storage       = "${var.dbstorage}"
    instance_class          = "${var.dbinstclass}"
    engine                  = "postgres"
    engine_version          = "9.6.2"
    publicly_accessible     = "true"
    username                = "invoicer"
    password                = "${var.db_password}"
    multi_az                = "false"
    skip_final_snapshot     = "true"
    tags                    = [
        {"environment-name" = "invoicer-api"},
        {"Owner"            = "neil"}
    ]
}
