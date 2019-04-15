#!/bin/bash


function ver_root 
{
if [ $(whoami) != root ]
	then	
		echo "Debe ser root para poder ejecutar este script"
		sleep 3
		clear
		exit
		fi
}

