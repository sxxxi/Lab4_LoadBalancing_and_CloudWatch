variable "vpc_cidr" {
  type = string
}
variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
    visibility = string
  }))
}
variable "private_subnets" {
  type = list(object({
    cidr = string
    az   = string
    visibility = string
  }))
}
variable "nat_subnet_id" {
  type = string
}
variable "alb_subnet_ids" {
  type = list(string)
}
variable "key_name" {
  type = string
}
variable "default_tags" {
  type = map(string)
}