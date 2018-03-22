provider "aws" {
  version = "~> 1.10"
}
provider "random" {
  version = "~> 1.1"
}

resource "random_id" "bucket_name" {
  byte_length = 8
}
module "backend" {
  source = "../"

  bucket    = "${random_id.bucket_name.hex}-tfstate"
  operators = ["${var.operator}"]
}
