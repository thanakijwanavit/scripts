#!/bin/bash
docker run -it -v $HOME/Downloads/:/home/jovyan/work -v $HOME/scripts/jupyter/.jupyter:/home/jovyan/.jupyter -p 8888:8888 thanakijwanavit/jupyter_cuda:latest
