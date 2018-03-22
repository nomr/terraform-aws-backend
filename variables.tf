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

variable "allowed_workspace" {
  description = "The allowed Terraform workspace name to create the backend resources"
  default = "default"
}

variable "role" {
  description = "The name of the Terraform role."
  default     = "terraform"
}
variable "create_role" {
  default = "true"
}
variable "services" {
  type        = "list"
  description = "The list of Services that can assume the Terraform role."
  default = [
    "codepipeline.amazonaws.com",
    "codebuild.amazonaws.com",
    "ec2.amazonaws.com",
  ]
}
variable "operators" {
  type        = "list"
  description = "The list of Users who can assume the terraform role."
  default     = []
}

variable "role_policies" {
  description = "The policies to attach to the Terraform role"
  default = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
