#!/bin/sh

############################################################################################################
#													   #
#													   #
#		Extension Attribute to sniff out corporate passwords					   #
#		contained with users' Stickies databases then reports					   #
#		back to JSS. Just modify the first two variables with					   #
#		your relavent passwords.								   #
#													   #
#		Written by Christian Dwyer 24th August 2018						   #
#													   #
#													   #
############################################################################################################

#Your corporate passwords go here:
wifiPass='WIFI PASSWORD'
ladminPass='LADMIN PASSWORD'


#Identifies logged on user
currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

#Creates temporary directory in users home directory
mkdir /Users/$currentUser/Library/tmp

#Creates temporary file in new directory containing user's Stickies data
cp /Users/$currentUser/Library/StickiesDatabase /Users/$currentUser/Library/tmp/StickiesDatabase1.txt

#Copies file data to variable
fileData=$(cat /Users/$currentUser/Library/tmp/StickiesDatabase1.txt)


#Checks variable for local admin password string
search=$(echo "$fileData" | grep -o "$ladminPass")

#If found sets variable status
if [[ $search != "" ]]; then
	found="ladmin"
else
	found="None"
fi

#Repeats above with corporate wifi password
search=$(echo "$fileData" | grep -o "$wifiPass")
if [[ $search != "" ]]; then
	if [[ "$found" == "ladmin" ]];then
    	found="ladmin and wifi"
    else
    	found="wifi"
    fi
else
	found="None"
fi

#Removes temp file securely
rm -Prf /Users/$currentUser/Library/tmp/

#Echos result to JSS
echo "<result>$found</result>"

#Exits bash instance
exit 0
