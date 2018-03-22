terraform {
  backend "s3" {
    region = "${region}"
    bucket = "${bucket}"
    key    = "${key}"
    dynamodb_table = "${dynamodb_table}"
  }
}
