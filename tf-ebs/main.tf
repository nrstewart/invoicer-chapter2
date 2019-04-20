data "aws_vpcs" "default_vpc" {
    tags              = {
              service = "invoicer-chapter2"
    }
}

module "db" {
    source            = "./db"
    identifier        = "${var.identifier}"
    db_security_group = "${aws_security_group.ivcr_postgresDB.id}"
    db_password       = "${random_string.db_password.result}"
}

module "application" {
    source            = "./app"
    identifier        = "${var.identifier}"
    db_password       = "${random_string.db_password.result}"
    db_hostname       = "${module.db.db_hostname}"
    db_security_group = "${aws_security_group.ivcr_postgresDB.id}"
}

resource "random_string" "db_password" {
    length            = 16
    special           = false
}

resource "aws_security_group" "ivcr_postgresDB" {
    name              = "${var.identifier}"
    description       = "access control to Invoicer Postgres DB"
    vpc_id            = "${element(flatten(data.aws_vpcs.default_vpc.*.ids), 0)}"
}
