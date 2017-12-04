# multi ping unter Linux
- tool unter Linux `fping` oder `oping`

## Install .deb like Distribution
- `apt-get install fping oping `

## commandline fping
- `fping -A < ip.txt`

## commandline oping
- `oping -4 -c 4 -i 2 -f ip.txt`
### oping option
- `-4` für IPv4
- `-c $number` wie oft
- `-i $number` wie lange bis zum nächsten ping
- `-f $file` Datei mit Liste der IP's
- siehe manpage
