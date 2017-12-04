#!/bin/bash
#http://www.cyberciti.biz/tips/linux-iptables-10-how-to-block-common-attack.html
#http://sharadchhetri.com/2013/06/15/how-to-protect-from-port-scanning-and-smurf-attack-in-linux-server-by-iptables/

INDEV=br-ffharz
SPORT="7 139"

iptables --flush scan 
iptables --delete-chain scan
iptables --new-chain scan

iptables -A scan -f -j DROP
iptables -A scan -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT
iptables -A scan -p tcp --tcp-flags ALL ALL -j DROP
iptables -A scan -p tcp --tcp-flags ALL NONE -j DROP
iptables -A scan -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A scan -m recent --name portscan --remove

for x in $SPORT;
do
	iptables -A scan -p tcp -m tcp --dport $x -m recent --name portscan --set -j LOG --log-prefix "portscan:"
	iptables -A scan -p tcp -m tcp --dport $x -m recent --name portscan --set -j DROP
	iptables -A scan -p udp -m udp --dport $x -m recent --name portscan --set -j LOG --log-prefix "portscan:"
	iptables -A scan -p udp -m udp --dport $x -m recent --name portscan --set -j DROP
done


iptables -A INPUT   -i $INDEV -j scan 
iptables -A FORWARD -i $INDEV -j scan 
