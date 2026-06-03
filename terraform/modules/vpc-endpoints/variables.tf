variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "route_table_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "aws_region" { type = string }
variable "tags" { type = map(string) default = {} }
