#!/usr/bin/env bash
sudo mount -t vboxsf c /home/nic/c -o umask=0022,gid=1000,uid=1000
sudo mount -t vboxsf d /home/nic/d -o umask=0022,gid=1000,uid=1000
