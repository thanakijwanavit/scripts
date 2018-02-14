#!/bin/bash

#######function text#######

usage="$(basename "$0") [-h] [-s n] -- put bash software into root command shortkey for example use './putincommandlist function shortkey' to create a shortkey of function called shortkey

where:
    -h  show this help text
    -s  set the seed value (default: 42)
	put in file name and the command name in the format 
	$basename filename command "
nameseed=42
while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) seed=$OPTARG
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











#######main program######
directory=$(pwd)'/'$1
name=$2

sudo ln -s $directory /usr/local/bin/$name
