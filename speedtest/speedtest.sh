#!/bin/bash
# -*- coding: utf-8 -*-
#
#  speedtest.sh
#
#  Copyright 2016 M. Schmalle <m.schmalle@harz.freifunk.net>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

wget http://10.7.100.2/speedtest/config.ini
wget http://10.7.100.2/speedtest/mysql
wget http://10.7.100.2/speedtest/speedtest-cli
chmod +x mysql
chmod +x speedtest-cli

source config.ini

function zusammenfassung () {
	clear
    echo ""
    echo "Das Ergebnis des Speedtests:"
    echo "----------------------------"
    echo ""
    echo "Datum:" $datum1
    echo "Uhrzeit:" $zeit
    echo "Knoten: " $knoten
    echo "Gatway: " $server
    echo "Extern DL: " $ext_dl
    echo "Extern UL: " $ext_ul
    echo "Performace Datei: " $pf
    echo "Intern DL: " $int_dl
    echo ""
}

function mysql () {
    QUERY="INSERT INTO $mysql_table (ID,knoten,date,time,server,ext_dl,ext_ul,int_file,int_dl) VALUES ('','$knoten','$datum','$zeit','$server','$ext_dl','$ext_ul','$pf','$int_dl')"
	echo $QUERY | ../mysql --host='$mysql_server' --user='$mysql_user' --password='$mysql_password' --database='$mysql_db'

    echo "Die Daten wurden an unseren Server übertragen"
}

function sammeln () {
	echo "Speedtest EXTERN und FF-Harz Netzwek für Knoten $knoten"
    echo ""

    echo "externer Down- und Upload wird ermittelt ... dies kann einen Moment dauern"
    ../speedtest-cli | egrep '(from|Down|Up)' > extern

	echo "interner Download wird ermittelt mit einer $pf Datei ... dies kann einen Moment dauern"
    wget -O /dev/null $file 2>&1 | grep -o "[0-9.]\+ [KM]*B/s" > intern
}

function grep_data () {
	grep -o "Download: [0-9.]\+ Mbit/s" extern > extern_dl
	grep -o "Upload: [0-9.]\+ Mbit/s" extern >extern_ul

	server=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" extern)
	ext_dl=$(grep -o "\([0-9.]\+ Mbit/s\)" extern_dl) #MB/S
        ext_ul=$(grep -o "\([0-9.]\+ Mbit/s\)" extern_ul) #MB/s
        int_dl=$(grep -o "\([0-9.]\+ [KM]B/s\)" intern) #kb/s
}

function verzeichnis () {
	clear
    mkdir $datum 2>/dev/null
    cd $datum
}

function loeschen () {
	rm *
	cd ..
	rmdir $datum
	rm config.ini
	rm mysql
	rm speedtest-cli
}

case "$2" in
  -64mb)
    pf=64MB
    file=$mb64
    verzeichnis
    sammeln
    grep_data
    zusammenfassung
    mysql
    loeschen
    ;;

  -128mb)
    pf=128MB
    file=$mb128
    verzeichnis
    sammeln
    grep_data
    zusammenfassung
    mysql
    loeschen
  ;;

  -256mb)
    pf=256MB
    file=$mb256
    verzeichnis
    sammeln
    grep_data
    zusammenfassung
    mysql
    loeschen
    ;;

  -512mb)
    pf=512MB
    file=$mb512
    verzeichnis
    sammeln
    grep_data
    zusammenfassung
    mysql
    loeschen
    ;;

  -1gb)
    pf=1GB
    file=$gb1
    verzeichnis
    sammeln
    grep_data
    zusammenfassung
    mysql
    loeschen
    ;;
  *)
esac

case "$1" in
  "")
    clear
    echo "Usage: $0 {Knotenname} -{64mb|128mb|256mb|512mb|1gb}"
    echo ""
    echo "1. Parameter:"
    echo "   Knotenname ist dann die TXT Datei mit dem Ergebnis"
    echo ""
    echo "2. Parameter:"
    echo "   die Größe der Datei die intern runtergeladen werden soll"
    ;;
  *)
esac
exit 0
