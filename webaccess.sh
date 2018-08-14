#!/usr/bin/env bash

tmux new-session -s webaccess -d "links http://hommesook.tarad.com/;read"

sleep 10 && tmux kill-session -t webaccess
# * 3 * * * /home/ubuntu/scripts/webaccess.sh