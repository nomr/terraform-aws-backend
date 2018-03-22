terraform {
  backend "s3" {
    role_arn       = "${role_arn}"
    region         = "${region}"
    bucket         = "${bucket}"
    key            = "${key}"
    dynamodb_table = "${dynamodb_table}"
  }
}
