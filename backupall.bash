#!/bin/bash


# backupall.bash
# Purpose: Creates backup of all vm's both assignment and regular(vm1,2,3)
#
# 
#
# Author: *** shadeunicorns ***
# Date: *** June 5th 2019 ***
# Revised: *** October 11th 2019 ***

if [ $PWD != "/root/bin" ] # only runs if in root's directory
then
 echo "You must be located in /root/bin" >&2
 exit 1
fi

####### declare color variable for color coding the text
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
NC='\033[0m'
BLUE='\033[0;34m'

#############################
x=$(ls -l /var/lib/libvirt/images/*.qcow2 | wc -l)
#counts the number of .qcow2 files in the directory in case a count in a loop is needed in the future
#############################
clear
printf "${BLUE}Here are the $x VM(s) found in the /var/lib/libvirt/images Directory:${NC}\n"
printf "${ORANGE}#----------#${NC}\n" #Displays a headder bar
for file in /var/lib/libvirt/images/*.qcow2 #loops through all the file names ending in .qcow2
do
	name=$(basename $file | cut -d. -f1) #take the path and extension off the vm to save space on screen
printf "${ORANGE}$name ${NC}\n"
done
printf "${ORANGE}#----------#${NC}\n" #Displays another bar to seperate lines onscreen
echo "" #blank line
	read -p "These are all the VMs that will be backed up along with their xml config files; Proceed (y|n):" resp 


if [ "$resp" = "y" ]
then
for filename in /var/lib/libvirt/images/*.qcow2
do
	vmname=$(basename $filename | cut -d. -f1) #removes path and extension from file to allow the $vmname variable to be used for the xml config
	printf "Backing up the .qcow2 file for ${CYAN}$vmname ${NC}\n"
		gzip < /var/lib/libvirt/images/$vmname.qcow2 | pv -l > /backup/full/$vmname.qcow2.backup.gz #backup the vm qcow file
	printf "Backup of ${CYAN}$vmname's ${NC} .QCOW2 File ${GREEN}DONE ${NC}\n"
	echo "Now Backing up the .xml config file for $vmname"
		gzip < /etc/libvirt/qemu/$vmname.xml | pv -l > /backup/full/$vmname.xml.backup.gz #use the $vmname to backup the .xml file
	printf "Backup of $vmname's .XML File ${GREEN}DONE ${NC}\n"
done
	printf "all $x VM(s) Backed up ${GREEN}suscessfully${NC}\n" #alert the user that the  program was run sucsessfully and print
	else
	printf "No VMs or their xml config files have been backed up.... ${RED}Aborting program${NC}\n"
	exit

fi;

