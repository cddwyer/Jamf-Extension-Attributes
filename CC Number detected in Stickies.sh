#!/bin/sh

#This checks user's stickies for credit card numbers 

currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

# Creates temporary directory in users home directory
mkdir /Users/$currentUser/Library/tmp

# Creates temporary file in new directory
cp /Users/$currentUser/Library/StickiesDatabase /Users/$currentUser/Library/tmp/StickiesDatabase1.txt

# Formats data in file
fileData=$(cat /Users/$currentUser/Library/tmp/StickiesDatabase1.txt)
cleanData=${fileData//[^[:alnum:]]/}
formattedData=$(echo "$cleanData"| LC_ALL=C tr -d -c '[:alnum:]')

# Searches for any 16+ digit strings (credit card number)
search=$(echo "$formattedData" | grep -o '[0-9]\{16\}')
if [[ $search != "" ]]; then
	# If finds longer than 16+ digit string, result is 1
	echo "<result>CC number detected</result>"
else
	# If does not find any 16+ digit string, result is 0
	echo "<result>No CC found</result>"
fi

rm -rf /Users/$currentUser/Library/tmp/

exit 0


