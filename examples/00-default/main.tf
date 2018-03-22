provider "aws" { version = "~> 1.10" }
provider "random" { version = "~> 1.1" }

data "aws_region" "current" { }

resource "random_id" "bucket_name" {
  byte_length = 8
}
module "backend" {
  source = "../.."

  region    = "${data.aws_region.current.name}"
  bucket    = "${random_id.bucket_name.hex}-tfstate"
  operators = ["${var.operator}"]
}
