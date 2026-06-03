variable "name" { type = string }
variable "subnet_id" { type = string }
variable "security_group_ids" { type = list(string) }
variable "instance_type" { type = string default = "t3.micro" }
variable "tags" { type = map(string) default = {} }
