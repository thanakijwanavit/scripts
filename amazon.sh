#!/bin/bash

keyfile=$(locate amazonfree.pem)

echo $keyfile is used as the  keyfile

ssh -i $keyfile ubuntu@ec2-54-70-87-233.us-west-2.compute.amazonaws.com
#/home/$USER/scripts/amazonfree.pem
