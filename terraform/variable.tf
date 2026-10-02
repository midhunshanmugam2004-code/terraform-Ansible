variable "aws_region" {
  description = "aws region"
  type        = string
}
variable "ami_id" {
  description = "ami id"
  type        = string
}
variable "instance_type" {
  description = "instance type"
  type        = string
}
variable "key_name" {
  description = "key name"
  type        = string
}
variable "private_key_path" {
  description = "path to the private key"
  type        = string
}
