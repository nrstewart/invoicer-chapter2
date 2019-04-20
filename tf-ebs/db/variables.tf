variable "db_security_group" {}
variable "db_password"       {}
variable "identifier"        {}
variable "dbstorage" {
    default = "5"
}
variable "dbinstclass" {
    default = "db.t2.micro"
}
