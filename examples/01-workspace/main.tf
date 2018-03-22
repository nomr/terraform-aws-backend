resource "random_id" "bucket_name" {
  byte_length = 8
}
module "backend" {
  source = "../.."

  bucket    = "${random_id.bucket_name.hex}-tfstate"
  operators = ["${var.operator}"]

  allowed_workspace = "backend"
}
