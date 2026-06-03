# AWS Enterprise Network Design

## Design Goal

Mục tiêu của dự án mới là chuyển mô hình mạng doanh nghiệp từ Cisco Packet Tracer sang AWS theo hướng cloud-native, có thể triển khai tự động, có thể mở rộng và dễ kiểm soát bằng Infrastructure as Code.

## Core Design

- Main Office VPC đại diện cho trụ sở chính.
- Branch Office VPC đại diện cho chi nhánh.
- Shared Services VPC đại diện cho vùng DC/server.
- AWS Transit Gateway đóng vai trò hub định tuyến giữa các VPC.
- NAT Gateway cung cấp đường ra Internet cho private subnet.
- AWS Client VPN cung cấp kết nối remote access cho nhân viên.
- Security Group và route table thay thế ACL và chính sách routing trên router/switch.
- VPC Flow Logs và CloudWatch Logs cung cấp khả năng giám sát lưu lượng.
- VPC Endpoints cho phép EC2 private subnet truy cập dịch vụ AWS mà không cần public IP.

## Segmentation Model

Trong Packet Tracer, VLAN tạo phân đoạn ở layer 2. Trên AWS, phân đoạn được biểu diễn bằng private subnet theo từng phòng ban, ví dụ:

| Department | AWS Subnet |
|---|---|
| STAFF | `10.10.10.0/24` |
| DEV | `10.10.20.0/24` |
| TESTER | `10.10.30.0/24` |
| HR | `10.10.40.0/24` |
| BA | `10.10.50.0/24` |
| PM | `10.10.60.0/24` |
| TECH | `10.10.70.0/24` |
| GUEST | `10.10.80.0/24` |
| CEO | `10.10.90.0/24` |

## Routing Model

Packet Tracer dùng OSPF và GRE/IPsec. AWS không chạy OSPF giữa VPC native. Dự án này thay bằng Transit Gateway:

- Main Office VPC route tới Branch và Shared Services qua TGW.
- Branch Office VPC route tới Main và Shared Services qua TGW.
- Shared Services VPC route tới Main và Branch qua TGW.
- Guest subnet không có route tới TGW để mô phỏng internet-only.

## Security Model

- Workload private subnet không nhận inbound từ Internet.
- EC2 demo service dùng SSM Session Manager thay cho SSH public.
- Security Groups giới hạn traffic giữa các subnet.
- Guest network bị giới hạn egress, không được thiết kế để truy cập Shared Services.
- VPC Flow Logs được bật để ghi nhận metadata lưu lượng.

## High Availability

Packet Tracer dùng HSRP trên CoreSW1/CoreSW2. AWS không cần HSRP trong VPC. High availability được triển khai bằng:

- Multi-AZ subnet.
- Managed Internet Gateway.
- NAT Gateway theo AZ nếu bật chế độ production.
- Transit Gateway managed service.
- Client VPN target vào nhiều subnet nếu cần.
