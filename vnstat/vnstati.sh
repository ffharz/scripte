#!/bin/sh
# Visualisierter Netzwerkverkehr mit Vnstat
# Ausgabe der Dateien in das Webserververzeichnis stats/traffic
# https://gambaru.de/blog/2012/06/02/vnstat-und-vnstati-volumen-des-netzwerkverkehrs-ubersichtlich-visualisieren/

set -e

Target=”/home/linuxiuvat/linuxiuvat.de/stats/traffic/graph/”

# stündlich
/usr/bin/vnstati -h -o ${Target}vnstat_hourly.png

# täglich
/usr/bin/vnstati -d -o ${Target}vnstat_daily.png

# monatlich
/usr/bin/vnstati -m -o ${Target}vnstat_monthly.png

# Top10
/usr/bin/vnstati -t -o ${Target}vnstat_top10.png

# Zusammenfassung
/usr/bin/vnstati -s -o ${Target}vnstat_summary.png
