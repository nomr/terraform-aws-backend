variable "operator" {
  description = "Name of a user that can control Terraform"
}
variable "policies" {
  description = "The short paths to the desired Terraform policies"
  type = "list"
}
