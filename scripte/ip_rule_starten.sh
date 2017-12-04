#!/bin/bash

# erstellt von Thomas Warnecke

ip rule add from all fwmark 0x1 table freifunk
