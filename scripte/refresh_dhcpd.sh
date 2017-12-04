#!/bin/bash

#/etc/init.d/isc-dhcp-server stop
echo "" > /var/lib/dhcp/dhcpd.leases
rm /var/lib/dhcp/dhcpd.leases~
#/etc/init.d/isc-dhcp-server start
