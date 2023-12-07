variable "nat_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "igw_id" {
  type = string
}
variable "default_tags" {
  type = map(string)
}
