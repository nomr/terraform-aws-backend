variable "region" {
  description = "The region of the S3 bucket and DynamoDB lock table"
  default = "us-east-1"
}

variable "bucket" {
  description = "The Terraform state bucket"
}

variable "key" {
  description = "The Terraform state filename"
  default     = "terraform.tfstate"
}

variable "dynamodb_table_suffix" {
  default     = "lock"
  description = "The Terraform state lock table suffix"
}

variable "operators" {
  type = "list"
  description = "The list of terraform operators."
  default = []
}

variable "allowed_workspace" {
  description = "The allowed Terraform workspace name to create the backend resources"
  default = "default"
}
