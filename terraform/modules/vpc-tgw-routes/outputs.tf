output "route_count" {
  value = length(aws_route.to_tgw)
}
