data "aws_elastic_beanstalk_solution_stack" "docker" {
    name_regex          = "^64bit Amazon Linux (.*) running Docker(.*)$"
    most_recent         = true
}

data "aws_instance" "ebs_instance" {
    instance_id         = "${element(aws_elastic_beanstalk_environment.ivcr_ebs_env.instances, 0)}"
}

data "aws_security_group" "ebs_instance" {
    name                = "${element(data.aws_instance.ebs_instance.security_groups, 0)}"
}

resource "aws_elastic_beanstalk_application" "ivcr_ebs_app" {
    name                = "${var.identifier}"
    description         = "Invoicer"
}

resource "aws_elastic_beanstalk_application_version" "default" {
    name                = "invoicer-api"
    application         = "${var.identifier}"
    bucket              = "${aws_s3_bucket.default.id}"
    key                 = "${aws_s3_bucket_object.default.id}"

}

resource "aws_elastic_beanstalk_environment" "ivcr_ebs_env" {
    application         = "${aws_elastic_beanstalk_application.ivcr_ebs_app.name}"
    name                = "${var.identifier}-invoicer-api"
    description         = "Invoicer API environment"
    version_label       = "${aws_elastic_beanstalk_application_version.default.name}"
    tags                = [
        {"Owner"        = "neil"}
    ]
    solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker.name}"
    setting {
        namespace       = "aws:elasticbeanstalk:application:environment"
        name            = "INVOICER_USE_POSTGRES"
        value           = "yes"
    }
    setting {
        namespace       = "aws:elasticbeanstalk:application:environment"
        name            = "INVOICER_POSTGRES_USER"
        value           = "invoicer"
    }
    setting {
        namespace       = "aws:elasticbeanstalk:application:environment"
        name            = "INVOICER_POSTGRES_PASSWORD"
        value           = "${var.db_password}"
    }
    setting {
        namespace       = "aws:elasticbeanstalk:application:environment"
        name            = "INVOICER_POSTGRES_DB"
        value           = "invoicer"
    }
    setting {
        namespace       = "aws:elasticbeanstalk:application:environment"
        name            = "INVOICER_POSTGRES_HOST"
        value           = "${var.db_hostname}"
    }
    setting {
        namespace       = "aws:elasticbeanstalk:application:environment"
        name            = "INVOICER_POSTGRES_SSLMODE"
        value           = "disable"
    }
    setting {
        namespace       = "aws:autoscaling:launchconfiguration"
        name            = "IamInstanceProfile"
        value           = "aws-elasticbeanstalk-ec2-role"
    }
    tier                = "WebServer"
}
