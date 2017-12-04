#!/bin/bash 
set -e
BRTOOL=$(which brctl)
BATOOL=$(which batctl)

$BRTOOL addif $1 $2

$BATOOL it 10000
$BATOOL gw server 100000/100000
