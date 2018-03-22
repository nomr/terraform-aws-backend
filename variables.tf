variable "bucket" {
  description = "The Terraform state bucket"
}

variable "key" {
  description = "The Terraform state filename"
  default     = "terraform.tfstate"
}

variable "dynamodb_table" {
  default     = "terraform-state-lock"
  description = "The Terraform state lock table"
}

variable "operators" {
  type = "list"
  description = "The list of terraform operators."
  default = []
}


