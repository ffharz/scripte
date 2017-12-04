#!/bin/bash

EXIP=$1
INDEV=$2
SDSUB="10.0.0.0/16 169.254.0.0/16 172.16.0.0/12 127.0.0.0/8 192.168.0.0/16 224.0.0.0/4 240.0.0.0/5 0.0.0.0/8"
DDSUB="224.0.0.0/4 240.0.0.0/5 0.0.0.0/8 239.255.255.0/24"

iptables --flush rfc1918 
iptables --delete-chain rfc1918
iptables --new-chain rfc1918

for x in $SDSUB;
do
	iptables -A rfc1918 -s $x -m recent --name rfc1918 --set -j LOG --log-prefix "src-rfc1918:"
	iptables -A rfc1918 -s $x -m recent --name rfc1918 --set -j DROP
	if [ "$x" != "10.0.0.0/16" ]
	then
		iptables -A rfc1918 -d $x -m recent --name rfc1918 --set -j LOG --log-prefix "dest-rfc1918:"
		iptables -A rfc1918 -d $x -m recent --name rfc1918 --set -j DROP
	fi
done


iptables -A FORWARD -d 10.0.0.0/8 -o eth0 -m recent --name forward --set -j LOG --log-prefix "forward:"
iptables -A FORWARD -d 10.0.0.0/8 -o eth0 -m recent --name forward --set -j REJECT --reject-with icmp-net-unreachable
iptables -A FORWARD -d 172.16.0.0/12 -o eth0 -m recent --name forward --set -j LOG --log-prefix "forward:"
iptables -A FORWARD -d 172.16.0.0/12 -o eth0 -m recent --name forward --set -j REJECT --reject-with icmp-net-unreachable
iptables -A FORWARD -d 192.168.0.0/16 -o eth0 -m recent --name forward --set -j LOG --log-prefix "forward:"
iptables -A FORWARD -d 192.168.0.0/16 -o eth0 -m recent --name forward --set -j REJECT --reject-with icmp-net-unreachable

for x in $DDSUB;
do
	iptables -A rfc1918 -d $x -j DROP
done

iptables -A INPUT   -i $INDEV -j rfc1918
