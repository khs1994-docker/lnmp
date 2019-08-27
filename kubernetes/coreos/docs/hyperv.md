# Windows Hyper-v

## Windows Hyper-V 固定 IP

* https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/nested-virtualization

```bash
$ New-VMSwitch -Name k8s -SwitchType Internal

$ New-NetIPAddress -IPAddress 192.168.57.1 -PrefixLength 24 -InterfaceIndex 24

$ New-NetNat –Name LocalNAT –InternalIPInterfaceAddressPrefix 192.168.57.1/24

$ Get-NetAdapter "vEthernet (k8s)" | New-NetIPAddress -IPAddress 192.168.57.1 -AddressFamily IPv4 -PrefixLength 24

# windows client network settings

# $ Get-NetAdapter "Ethernet" | New-NetIPAddress -IPAddress 192.168.100.2 -DefaultGateway 192.168.100.1 -AddressFamily IPv4 -PrefixLength 24

# $ Netsh interface ip add dnsserver “Ethernet” address=<my DNS server>
```
