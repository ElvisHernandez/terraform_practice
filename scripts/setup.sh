#!/bin/bash

sudo fallocate -l 8G /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

while [ ! -f /tmp/build.sh ]
do
   sleep 10
   echo "waiting for provisioning files..."
done

chmod +x /tmp/*.sh
sudo bash /tmp/build.sh &> /tmp/build.log