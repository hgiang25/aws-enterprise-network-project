# Cisco Packet Tracer to AWS Design

This project converts the Cisco Packet Tracer enterprise network to AWS using cloud-native services.

## Cisco to AWS Mapping

| Cisco | AWS |
|---|---|
| VLANs | Private subnets |
| SVI routing | VPC route tables |
| ACLs | Network ACLs + Security Groups |
| GRE/IPsec/OSPF | Transit Gateway routing |
| NAT overload | NAT Gateway |
| Remote VPN | AWS Client VPN |
| DC subnet | Shared Services VPC |
| Guest internet-only | Guest subnet + no TGW route + restrictive NACL |
| HSRP / redundant routers | Multi-AZ AWS managed infrastructure |

## Important Note

AWS is not a Layer 2 campus switch network. The design preserves the functional behavior rather than copying Cisco CLI one-to-one.
