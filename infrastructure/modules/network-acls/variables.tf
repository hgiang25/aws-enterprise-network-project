variable "name" {
  type        = string
  description = "Name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "main_vpc_cidr" {
  type        = string
  description = "Main VPC CIDR."
}

variable "branch_vpc_cidr" {
  type        = string
  description = "Branch VPC CIDR."
}

variable "shared_vpc_cidr" {
  type        = string
  description = "Shared Services VPC CIDR."
}

variable "client_vpn_cidr" {
  type        = string
  description = "Client VPN CIDR."
}

variable "subnets" {
  type = map(object({
    subnet_id = string
    cidr      = string
    policy    = string
  }))
  description = "Subnet policy map."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
