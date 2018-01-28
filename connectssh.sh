#!/bin/bash
usage="$(basename "$0") [-h] [-s n] -- program to calculate the answer to life, the universe and everything

where:
    -h  show this help text
    -s  set the seed value (default: 42)
    -p set port (default 23456)
    -i amazon ip (default: 172.31.32.178)
    -c connect
"
seed=42
port=23456
ip='172.31.32.178'
while getopts ':hs:p:i:c' option; do
  case "$option" in
    c) tmux new-session -s amazon -d "cd /home/nic/scripts/ ;ssh -R $port:localhost:22 -i '/home/nic/scripts/amazonfree.pem' nic@$ip ;read"
       ;;
    h) echo "$usage"
       exit
       ;;
    s) seed=$OPTARG
       ;;
    p) port=$OPTARG
       ;;
    i) ip=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))





tmux new-session -s amazon -d "cd /home/nic/scripts/ ;ssh -R $port:localhost:22 -i 'amazonfree.pem' nic@$ip ;read"


