#!/bin/bash

echo "Please enter your name in the format of lastname_firstname."
read FOLDERNAME

echo "Please enter the username you used to create an account."
read USERNAME
# change to active directory
sudo mkdir /Volumes/pegasus_R6/data/ftp_server/active/$FOLDERNAME

sudo chown $USERNAME /Volumes/pegasus_R6/data/ftp_server/active/$FOLDERNAME

