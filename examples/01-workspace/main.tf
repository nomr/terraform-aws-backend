provider "random" { version = "~> 1.1" }

data "aws_region" "current" { }

resource "random_id" "bucket_name" {
  byte_length = 8
}
module "backend" {
  source = "../.."

  #region    = "${data.aws_region.current.name}"
  region    = "us-east-1"
  bucket    = "${random_id.bucket_name.hex}-tfstate"
  operators = ["${var.operator}"]

  allowed_workspace = "backend"
}
