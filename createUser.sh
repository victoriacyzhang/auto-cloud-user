#!/bin/bash

# if not root
if [[ $UID -ne 0 ]]; then echo "Please run $0 as root with sudo command." && exit 1; fi

echo "Please enter username"
read USERNAME

echo "Please enter full name"
read FULLNAME

echo "Please enter password"
read -s PASSWORD

GROUP="cmrgcloud"

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

echo "Done creating the user."

---------------------------------

echo "Now generating the ssh key."
echo "new" | ssh-keygen -t rsa

---------------------------------

echo "Now storing ssh key."

# need to create .ssh
sudo mkdir /Users/$USERNAME/.ssh
# need to create authorized_keys
sudo touch /Users/$USERNAME/.ssh/authorized_keys
# need to change permission of .ssh to 700
sudo chmod 700 /Users/$USERNAME/.ssh
# need to change permission of authorized_keys to 600
sudo chmod 600 /Users/$USERNAME/.ssh/authorized_keys
# copy content of new.pub to authorized_keys
sudo cp ~/auto-cloud-user/new.pub /Users/$USERNAME/.ssh/authorized_keys

--------------------------------

echo "Now linking ssh to cloud"

echo "Please enter your name in the format of lastname_firstname."
read FOLDERNAME

# change to active directory
sudo mkdir /Volumes/pegasus_R6/data/ftp_server/active/$FOLDERNAME

sudo chown $USERNAME /Volumes/pegasus_R6/data/ftp_server/active/$FOLDERNAME

echo "Done."
