variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(object({
    cidr = string
    az   = string
    visibility = string
  }))
}

variable "default_tags" {
  type = map(string)
}

