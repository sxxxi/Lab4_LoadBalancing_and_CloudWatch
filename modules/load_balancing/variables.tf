variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "alb_subnet_ids" {
  type = list(string)
}
variable "alb_sg_ids" {
  type = list(string)
}
variable "key_name" {
  type = string
}
variable "launch_template_sg_ids" {
  type = list(string)
}
variable "default_tags" {
  type = map(string)
}
