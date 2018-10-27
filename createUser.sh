#!/bin/bash

echo "Please enter username"
read USERNAME

echo "Please enter full name"
read FULLNAME

echo "Please enter password"
read -s PASSWORD

GROUP="cmrgcloud"

# if is not root
if [[ $UID -ne 0 ]]; then echo "Please run $0 as root with sudo command." && exit 1; fi

# Find out the next available user ID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

# Create the user account
dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME RealName "$FULLNAME"
dscl . -create /Users/$USERNAME UniqueID "$USERID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
dscl . -append /Users/$USERNAME Picture "/Library/User Pictures/Flowers/Lotus.tif"
dscl . -passwd /Users/$USERNAME $PASSWORD

# add to cloud group
dseditgroup -o edit -t user -a $USERNAME $GROUP
echo "Added user to cloud group"

#Create the home directory
createhomedir -c -u $USERNAME

echo "Done."
