#!/usr/bin/env bash
#su nic #change user to nic
source /home/nic/miniconda3/bin/activate learnai #change environment to learnai
tmux new-session -s jupyter -d "source activate learnai ;jupyter notebook ;read"
