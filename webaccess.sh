#!/usr/bin/env bash

tmux new-session -s webaccess -d "links http://hommesook.tarad.com/;read"

sleep 10 && tmux kill-session -t webaccess
# 1 * * * * /home/ubuntu/scripts/webaccess.sh



##### how to use #####
#install tmux, links by running
#sudo apt-get install tmux links
#crontab -e
#add "1 * * * * /home/ubuntu/scripts/webaccess.sh" to crontab