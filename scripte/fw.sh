#!/bin/bash

EXDEV="eth0 br-ffharz"
INDEV="lo bat0 mesh-vpn+ bridge"
INTCP="656 2222 65333"
INUDP="656 2222 9998:10003 101000"
P2PDROP='100bao xunlei eMule emule emuleforum p2pworld emule-project filedonkey BitTorrent announce.php?passkey torrent announce info_hash .torrent peer_id='
OUTIPV6="2a02:7aa0:1619::6de:8f05/96"
INIPV6="2a01:4f8:141:44a3::2 2a01:4f8:100:62e7::2 2a01:4f8:d13:5155::2 2a02:7aa0:1619::6de:8f05"
EXIP=$(ifconfig eth0 | grep "inet addr" | cut -d : -f 2 |cut -d " " -f 1)


echo 128000 > /proc/sys/net/netfilter/nf_conntrack_max || true
echo 14400 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established || true
echo 300 > /proc/sys/net/netfilter/nf_conntrack_generic_timeout || true

iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
ip6tables -F INPUT
ip6tables -F FORWARD
ip6tables -F OUTPUT
iptables -t mangle -F PREROUTING 
iptables -t mangle -F FORWARD
iptables -t nat -F POSTROUTING

iptables -P INPUT DROP

#iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300



for x in $INDEV
do
	iptables -A INPUT -i $x -j ACCEPT
done

for x in $DROPSN
do
	if [ $x != "10.0.0.0/8" ]; then
		iptables -A INPUT -i br-ffharz -s 10.7.0.0/16 -d $x -j DROP
	        iptables -A OUTPUT -d $x -p udp -j DROP
		iptables -A OUTPUT -s $x -p udp -j DROP
		iptables -A INPUT -s $x -p udp -j DROP
	fi
	iptables -A OUTPUT -o eth0 -d $x -j DROP
done

for x in $EXDEV
do
	iptables -A INPUT -p icmp  -i $x --icmp-type echo-request -j ACCEPT
	iptables -A INPUT -m state -i $x --state ESTABLISHED,RELATED -j ACCEPT
done

for x in $INTCP
do
        iptables -A INPUT -m state --state NEW -p tcp --dport $x --tcp-flags ALL SYN -j ACCEPT
done

for x in $INUDP
do
	iptables -A INPUT -p udp --dport $x -j ACCEPT
done

iptables -t nat -j SNAT -s 10.7.0.0/16 --to-source $EXIP -o eth0 -A POSTROUTING

ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A FORWARD -m conntrack --ctstate INVALID -j DROP
ip6tables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A OUTPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP
iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

/root/scripte/scan.sh $EXIP
/root/scripte/rfc1918.sh $EXIP br-ffharz
/root/scripte/torrent.sh $EXIP
