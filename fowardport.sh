#!/bin/bash
usage="$(basename "$0") [-h] [-s n] -- foward port to amazon server -f port from -p port to

where:
    -h  show this help text
    -s  set the seed value (default: 42)
    -p set port to (default 10000)
    -i amazon ip (default: 172.31.32.178)
    -c connect
    -f port from (default:80)
"
number=$((RANDOM % 10))
from=80
seed=42
port=23456
ip='ec2-54-70-87-233.us-west-2.compute.amazonaws.com'
while getopts ':hs:p:i:cf:' option; do
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
    f) from=$OPTARG
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





tmux new-session -s fowardportfrom${from}to${port} -d "cd /home/nic/scripts/ ;autossh -R *:$port:localhost:$from -i 'amazonfree.pem' ubuntu@$ip ;read"


