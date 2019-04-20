resource "aws_s3_bucket" "default" {
    bucket = "${var.identifier}"
}

resource "aws_s3_bucket_object" "default" {
    bucket = "${aws_s3_bucket.default.id}"
    key    = "app-version.json"
    source = "files/app-version.json"
}
