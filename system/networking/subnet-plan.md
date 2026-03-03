# Subnet Plan (Reference)

- MGMT: 10.10.0.0/24
- SERVER: 10.10.10.0/24
- APP: 10.10.20.0/24
- DMZ: 10.10.30.0/24

Routing:
- Default route to firewall
- No direct internet access to SERVER/APP except via NAT/proxy as required
