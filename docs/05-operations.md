# Operations Runbook

## Daily Checks

- Kiểm tra Terraform drift bằng `terraform plan`.
- Kiểm tra VPC Flow Logs trong CloudWatch.
- Kiểm tra trạng thái Transit Gateway attachments.
- Kiểm tra NAT Gateway metrics nếu workload cần Internet.
- Kiểm tra Client VPN connection logs nếu bật VPN.

## Troubleshooting Connectivity

1. Kiểm tra route table của subnet nguồn.
2. Kiểm tra route table của subnet đích.
3. Kiểm tra Transit Gateway attachment và TGW route table.
4. Kiểm tra Security Group inbound/outbound.
5. Kiểm tra NACL nếu bạn bổ sung NACL tùy chỉnh.
6. Kiểm tra Flow Logs để xác định `ACCEPT` hoặc `REJECT`.

## Common Issues

### Private instance không ra Internet

- Kiểm tra private subnet route `0.0.0.0/0` tới NAT Gateway.
- Kiểm tra NAT Gateway nằm trong public subnet.
- Kiểm tra public subnet có route tới Internet Gateway.

### VPC này không ping được VPC khác

- Kiểm tra VPC route tới CIDR đích qua Transit Gateway.
- Kiểm tra TGW attachment đã ở trạng thái available.
- Kiểm tra Security Group có cho ICMP hoặc port cần dùng.

### Client VPN kết nối được nhưng không truy cập được private subnet

- Kiểm tra authorization rule.
- Kiểm tra client route.
- Kiểm tra security group gắn với Client VPN.
- Kiểm tra client CIDR không overlap với VPC CIDR.
