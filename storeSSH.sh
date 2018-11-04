#!/bin/bash

echo "What's your account username?"
read USERNAME

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
