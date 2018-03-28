provider "aws" { version = "= 1.10" }
provider "random" { version = "~> 1.1" }

data "aws_region" "current" { }
data "aws_caller_identity" "current" {}

data "aws_iam_policy" "policies" {
  count = "${length(var.policies)}"

  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:${var.policies[count.index]}"
}

resource "random_id" "bucket_name" {
  byte_length = 8
}
module "backend" {
  source = "../.."

  region    = "${data.aws_region.current.name}"
  bucket    = "${random_id.bucket_name.hex}-tfstate"
  operators = ["${var.operator}"]
  stacks    = ["${var.stacks}"]

  role_policies = [
    "${data.aws_iam_policy.policies.*.arn}"
  ]
}
