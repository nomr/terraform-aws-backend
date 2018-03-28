variable "operator" {
  description = "Name of a user that can control Terraform"
}
variable "policies" {
  description = "The short paths to the desired Terraform policies"
  type = "list"
}
variable "stacks" {
  description = "The name of the stacks to create"
  type = "list"
}
