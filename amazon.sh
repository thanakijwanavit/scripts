#!/bin/bash


: <<'COMMENT'
'''
#<<<<<<< HEAD
package='find'
#=======
keyfile=$(find $HOME/scripts -name amazonfree.pem)
#>>>>>>> f832b760c41dcc259e030e686eb0a07f5ce42fde

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $package|grep 'install ok installed')
echo Checking for locate: $PKG_OK
if [ "" == "$PKG_OK" ]; then
	echo 'installing' $package
	case $OSTYPE in 
	linux*) echo I am a linux
		sudo apt-get --force-yes --yes install $package 
		;; 
	*) 	echo "I am not a linux, please install $package manually"
   		;;
	esac
fi

if [ $package == 'locate' ]; then
	keyfile=$(locate amazonfree.pem)
	echo locate is used
fi

if [ $package == 'find' ]; then
	keyfile=$(find $HOME -name 'amazonfree.pem')
	echo find is used
fi	
echo $keyfile is used as the keyfile
chmod 400 $keyfile


ssh -i $keyfile ubuntu@ec2-54-70-87-233.us-west-2.compute.amazonaws.com

'''
COMMENT


ssh -i amazonfree.pem ubuntu@ec2-54-70-87-233.us-west-2.compute.amazonaws.com



#/home/$USER/scripts/amazonfree.pem


