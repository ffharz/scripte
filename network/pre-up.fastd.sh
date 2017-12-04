#!/bin/bash 
# Script für diverse Tunnel im Freifunk
# $TUNNEL steht für die Verzeichnissnamen, für die Tunnelkonfiguration
# das Device sollte entsprechend auch in der Tunnelkonfiguration hinterlegt sein

TUNNEL=$*
modprobe batman-adv
BINFASTD=$(which fastd)

for y in $TUNNEL 
do
	tunctl -t $y
	start-stop-daemon --start --quiet --oknodo --make-pidfile --pidfile /var/run/fastd.$y.pid -b --startas $BINFASTD -- -c /etc/fastd/$y/fastd.conf
	batctl interface add $y
done
