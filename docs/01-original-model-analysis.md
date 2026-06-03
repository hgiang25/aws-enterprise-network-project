# Original Packet Tracer Model Analysis

Mô hình Packet Tracer ban đầu đã triển khai được một mạng doanh nghiệp nhiều site, gồm trụ sở chính, chi nhánh, vùng DC/server và người dùng remote. Trụ sở chính có nhiều VLAN phòng ban như STAFF, DEV, TESTER, HR, BA, PM, TECH, GUEST và CEO. Các VLAN được định tuyến ở core switch bằng SVI, dùng HSRP để tạo default gateway ảo, DHCP relay về server nội bộ và ACL để hạn chế truy cập liên VLAN.

Về kết nối WAN, mô hình có router ISP giả lập, hai router tại trụ sở chính, hai router tại chi nhánh và router DC. Các site được kết nối bằng GRE tunnel và bảo vệ bởi IPsec. OSPF được dùng để trao đổi route nội bộ, NAT overload được dùng cho lưu lượng ra Internet, đồng thời có đường primary/backup thông qua cost và route dự phòng.

Về bảo mật, mô hình đã có guest network internet-only, ACL chặn guest truy cập mạng nội bộ, ACL chặn các VLAN phòng ban truy cập lẫn nhau nhưng vẫn cho phép truy cập vùng server. Ngoài ra còn có remote VPN client pool để nhân viên truy cập từ xa vào hệ thống doanh nghiệp.

Tóm lại, mô hình đã thể hiện tốt các ý tưởng quan trọng của mạng doanh nghiệp: phân đoạn mạng, dự phòng gateway, định tuyến động, kết nối site-to-site an toàn, NAT, remote access và chính sách truy cập theo từng nhóm người dùng.
