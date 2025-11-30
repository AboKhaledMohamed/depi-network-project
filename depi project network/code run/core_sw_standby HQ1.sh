system-view
sysname LSW4_standby_HQ1
undo info-center enable
aaa
 local-user admin password cipher Huawei@123
 local-user admin privilege level 15
 local-user admin service-type terminal telnet ssh
quit

header shell information "*** LSW4_standby_HQ1 - Unauthorized Access Prohibited ***"

vlan batch 10 20 30 40 50 

vlan 10
 description HR_Department
vlan 20
 description Sales_Department
vlan 30
 description IT_Department
vlan 40
 description Access_Points
vlan 50
 description Servers
quit

interface Vlanif10
 description HR Gateway
 ip address 10.10.10.3 255.255.255.0
 vrrp vrid 10 virtual-ip 10.10.10.1
 vrrp vrid 10 priority 100
 vrrp vrid 10 preempt-mode timer delay 10

interface Vlanif20
 description Sales Gateway
 ip address 10.10.20.3 255.255.255.0
 vrrp vrid 20 virtual-ip 10.10.20.1
 vrrp vrid 20 priority 100
 vrrp vrid 20 preempt-mode timer delay 10

interface Vlanif30
 description IT Gateway
 ip address 10.10.30.3 255.255.255.0
 vrrp vrid 30 virtual-ip 10.10.30.1
 vrrp vrid 30 priority 100
 vrrp vrid 30 preempt-mode timer delay 10

interface Vlanif40
 description Access Point Gateway
 ip address 10.10.40.3 255.255.255.0
 vrrp vrid 40 virtual-ip 10.10.40.1
 vrrp vrid 40 priority 100
 vrrp vrid 40 preempt-mode timer delay 10

interface Vlanif50
 description Servers Gateway
 ip address 10.10.50.3 255.255.255.0
 vrrp vrid 50 virtual-ip 10.10.50.1
 vrrp vrid 50 priority 100
 vrrp vrid 50 preempt-mode timer delay 10
quit

interface Eth-Trunk1
 description Link to LSW3 core_HQ1
 port link-type trunk
 port trunk allow-pass vlan 10 20 30 40 50
 mode lacp

interface GigabitEthernet0/0/2
 description Trunk Member to LSW3
 eth-trunk 1
 
interface GigabitEthernet0/0/3
 description Trunk Member to LSW3
 eth-trunk 1
quit

interface GigabitEthernet0/0/5
 description Uplink to LSW8 Access Switch
 port link-type trunk
 port trunk allow-pass vlan 10 20 30 40 50 
 undo shutdown
qu

interface GigabitEthernet0/0/4
 description Uplink to LSW7 Access Switch
 port link-type trunk
 port trunk allow-pass vlan 10 20 30 40 50 
 undo shutdown
qu

interface GigabitEthernet0/0/1
 description Uplink to Firewall
 port link-type trunk
 port trunk allow-pass vlan 10 20 30 40 50 
 undo shutdown
qu

dhcp enable

ip pool VLAN10_HR
 gateway-list 10.10.10.1
 network 10.10.10.0 mask 255.255.255.0
 excluded-ip-address 10.10.10.200 10.10.10.250
 dns-list 8.8.8.8 8.8.4.4

ip pool VLAN20_Sales
 gateway-list 10.10.20.1
 network 10.10.20.0 mask 255.255.255.0
 excluded-ip-address 10.10.20.200 10.10.20.250
 dns-list 8.8.8.8 8.8.4.4

ip pool VLAN30_IT
 gateway-list 10.10.30.1
 network 10.10.30.0 mask 255.255.255.0
 excluded-ip-address 10.10.30.200 10.10.30.250
 dns-list 8.8.8.8 8.8.4.4

ip pool VLAN40_AP
 gateway-list 10.10.40.1
 network 10.10.40.0 mask 255.255.255.0
 excluded-ip-address 10.10.40.200 10.10.40.250
 dns-list 8.8.8.8 8.8.4.4

interface Vlanif10
 dhcp select global

interface Vlanif20
 dhcp select global

interface Vlanif30
 dhcp select global

interface Vlanif40
 dhcp select global
quit

acl number 3010
 description VLAN10 - Allow only to VLAN50
 rule 10 permit ip source 10.10.10.0 0.0.0.255 destination 10.10.50.0 0.0.0.255
 rule 15 deny ip source 10.10.10.0 0.0.0.255 destination 10.10.20.0 0.0.0.255
 rule 20 deny ip source 10.10.10.0 0.0.0.255 destination 10.10.30.0 0.0.0.255
 rule 25 deny ip source 10.10.10.0 0.0.0.255 destination 10.10.40.0 0.0.0.255
 rule 30 permit ip source any destination any

acl number 3020
 description VLAN20 - Allow only to VLAN50
 rule 5 permit ip source 10.10.20.0 0.0.0.255 destination 10.10.50.0 0.0.0.255
 rule 10 deny ip source 10.10.20.0 0.0.0.255 destination 10.10.10.0 0.0.0.255
 rule 15 deny ip source 10.10.20.0 0.0.0.255 destination 10.10.30.0 0.0.0.255
 rule 20 deny ip source 10.10.20.0 0.0.0.255 destination 10.10.40.0 0.0.0.255
 rule 25 permit ip source any destination any

acl number 3030
 description VLAN30 - Allow only to VLAN50
 rule 5 permit ip source 10.10.30.0 0.0.0.255 destination 10.10.50.0 0.0.0.255
 rule 10 deny ip source 10.10.30.0 0.0.0.255 destination 10.10.10.0 0.0.0.255
 rule 15 deny ip source 10.10.30.0 0.0.0.255 destination 10.10.20.0 0.0.0.255
 rule 20 deny ip source 10.10.30.0 0.0.0.255 destination 10.10.40.0 0.0.0.255
 rule 25 permit ip source any destination any

acl number 3040
 description VLAN40 - Allow only to VLAN50
 rule 5 permit ip source 10.10.40.0 0.0.0.255 destination 10.10.50.0 0.0.0.255
 rule 10 deny ip source 10.10.40.0 0.0.0.255 destination 10.10.10.0 0.0.0.255
 rule 15 deny ip source 10.10.40.0 0.0.0.255 destination 10.10.20.0 0.0.0.255
 rule 20 deny ip source 10.10.40.0 0.0.0.255 destination 10.10.30.0 0.0.0.255
 rule 25 permit ip source any destination any
quit

interface Vlanif10
 traffic-filter inbound acl 3010

interface Vlanif20
 traffic-filter inbound acl 3020

interface Vlanif30
 traffic-filter inbound acl 3030

interface Vlanif40
 traffic-filter inbound acl 3040

stp mode rstp
stp region-configuration
 region-name CAMPUS_HQ1
 revision-level 1
 instance 1 vlan 10 20 30 40 50
 active region-configuration
quit
stp instance 1 priority 4096
stp bpdu-protection
stp enable

user-interface con 0
 authentication-mode password
 set authentication password cipher Huawei@123
 idle-timeout 0 0
quit

user-interface vty 0 4
 authentication-mode aaa
 protocol inbound telnet
protocol inbound ssh
 user privilege level 15
quit

stelnet server enable
ssh user admin
ssh user admin authentication-type password
ssh user admin service-type stelnet

return
save
