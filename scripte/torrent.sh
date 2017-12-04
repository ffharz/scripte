#!/bin/bash
#INPUTFILE=$1

iptables --flush torrent
iptables --delete-chain torrent
iptables --new-chain torrent 

# Block Torrent algo string using Boyer-Moore (bm)
iptables -A torrent -m string --algo bm --string "BitTorrent" -j DROP
iptables -A torrent -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A torrent -m string --algo bm --string "peer_id=" -j DROP
iptables -A torrent -m string --algo bm --string ".torrent" -j DROP
iptables -A torrent -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A torrent -m string --algo bm --string "torrent" -j DROP
iptables -A torrent -m string --algo bm --string "announce" -j DROP
iptables -A torrent -m string --algo bm --string "info_hash" -j DROP
iptables -A torrent -m string --algo bm --string "/default.ida?" -j DROP
iptables -A torrent -m string --algo bm --string ".exe?/c+dir" -j DROP
iptables -A torrent -m string --algo bm --string ".exe?/c_tftp" -j DROP
# Block Torrent keys
iptables -A torrent -m string --algo kmp --string "peer_id" -j DROP
iptables -A torrent -m string --algo kmp --string "BitTorrent" -j DROP
iptables -A torrent -m string --algo kmp --string "BitTorrent protocol" -j DROP
iptables -A torrent -m string --algo kmp --string "bittorrent-announce" -j DROP
iptables -A torrent -m string --algo kmp --string "announce.php?passkey=" -j DROP
# Block Distributed Hash Table (DHT) keywords
iptables -A torrent -m string --algo kmp --string "find_node" -j DROP
iptables -A torrent -m string --algo kmp --string "info_hash" -j DROP
iptables -A torrent -m string --algo kmp --string "get_peers" -j DROP
iptables -A torrent -m string --algo kmp --string "announce" -j DROP
iptables -A torrent -m string --algo kmp --string "announce_peers" -j DROP 

iptables -A FORWARD -i br-ffharz --jump torrent
