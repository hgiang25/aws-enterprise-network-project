# Security Design

## Main Principles

- Không expose EC2 private service ra Internet.
- Không commit secrets vào GitHub.
- Dùng SSM Session Manager thay cho SSH public.
- Dùng Security Groups để kiểm soát inbound/outbound.
- Dùng VPC Flow Logs để phục vụ audit.
- Tách VPC theo chức năng: Main, Branch, Shared Services.
- Guest subnet không được định tuyến sang Transit Gateway.

## Suggested Security Extensions

Dự án đã chừa cấu trúc để mở rộng thêm:

- AWS Network Firewall cho inspection tập trung.
- AWS WAF nếu triển khai public web application.
- GuardDuty để phát hiện hành vi bất thường.
- Security Hub để tổng hợp finding.
- AWS Config để kiểm tra drift và compliance.
- IAM Identity Center để quản lý quyền truy cập người dùng.

## Secrets Handling

Không lưu các thông tin sau trong Git:

- AWS access key.
- Private key SSH.
- VPN certificate/private key.
- File `.tfvars` chứa ARN/cấu hình nhạy cảm.
- Terraform state file.

## Remote Access

Remote access nên đi qua AWS Client VPN và sau đó truy cập private service bằng private IP hoặc private DNS. Không nên mở SSH/RDP trực tiếp ra Internet.
