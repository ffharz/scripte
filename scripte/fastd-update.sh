#!/bin/bash
# Script für das Update der peers Konfigurationsdatein für fastd
# Freifunk Harz e.V. - Steffen Taubenheim-Probst
# Lizenz: GPL
# Datum: 12.08.2015
# Script als cronjob ausführen (zum Beispiel alle 2h)


set -e

FASTDDIR="/etc/fastd/freifunk"
FASTDPEERS="$FASTDDIR/peers"
GITREPO="https://git.harz.freifunk.net/ff-harz/fastd-peers.git"

if [ ! -d $FASTDDIR ]; then
	echo "fastd bitte einrichten."
	exit 0
fi

if [ ! -d $FASTDPEERS ]; then
        cd $FASTDDIR
        git clone $GITREPO
        ln -s $FASTDDIR/fastd-peers $FASTDPEERS
        pkill -HUP fastd
        exit 0
fi

if  [ -d $FASTDPEERS ]; then
        cd $FASTDPEERS
        git pull
        pkill -HUP fastd
fi

exit 0
