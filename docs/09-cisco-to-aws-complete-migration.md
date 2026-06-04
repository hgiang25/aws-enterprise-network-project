# Cisco Packet Tracer to AWS Complete Migration Notes

This upgrade moves the AWS design closer to the working Cisco Packet Tracer model.

## Functional mapping

| Cisco feature | AWS implementation in this upgrade |
|---|---|
| VLAN 10/20/30/40/50/60/70/80/90 | Main VPC private subnets STAFF/DEV/TESTER/HR/BA/PM/TECH/GUEST/CEO |
| VLAN ACLs | Per-subnet Network ACL policy module + Security Groups |
| Guest internet-only ACL | Guest NACL denies Main, Branch, Shared, VPN CIDR and private ranges, then allows Internet egress |
| DC/server subnet | Shared Services VPC private subnets |
| OSPF/GRE between sites | Transit Gateway attachments and route tables |
| NAT overload | NAT Gateway per AZ when `single_nat_gateway = false` |
| R1/R2 and CoreSW1/CoreSW2 redundancy | Multi-AZ subnets, multi-AZ NAT, managed TGW, multi-subnet Client VPN association |
| Remote VPN client pool | AWS Client VPN with certificate authentication, authorization rules and route table entries |
| DHCP relay to internal DHCP server | AWS VPC managed DHCP. Use DHCP options if custom DNS/domain is required. |
| Flow visibility | VPC Flow Logs and CloudWatch Logs |

## Important design decision

AWS is not a layer-2 campus network. VLAN trunks, STP, HSRP, GRE interfaces and OSPF adjacency are not copied literally. The functional intent is preserved using cloud-native AWS primitives.

## Traffic policy after this upgrade

- Main department subnets can reach Shared Services and Internet.
- Main department subnets cannot laterally reach other Main department subnets through subnet boundary rules.
- Guest subnet is Internet-only.
- Branch subnets can reach Shared Services and Internet, but not Main user subnets by default.
- Shared Services accepts traffic from Main, Branch and Client VPN.
- Client VPN users get routes to Main, Branch and Shared Services, while Guest remains protected by NACL policy.
