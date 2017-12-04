#!/bin/bash 

for x in $*
do
	batctl interface del $x
	start-stop-daemon --stop --quiet --oknodo --retry 30 --pidfile /var/run/fastd.$x.pid
	tunctl -d $x
done
