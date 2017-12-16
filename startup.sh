#!/bin/bash
#sudo useradd nic
#sudo passwd nic
#sudo usermod -aG sudo nic
#su nic
sudo ./gitconfig.sh
sudo apt-get install tmux
sudo ./putallincommandlist.sh

sudo chmox 400 nicwanavit.pem
