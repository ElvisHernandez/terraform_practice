#!/bin/bash

echo "127.0.0.1 bastion.nerdlythinking.com" | sudo tee --append /etc/hosts
echo "127.0.0.1 phpmyadmin.nerdlythinking.com" | sudo tee --append /etc/hosts
echo "127.0.0.1 directus.nerdlythinking.com" | sudo tee --append /etc/hosts
echo "127.0.0.1 gatsby.nerdlythinking.com" | sudo tee --append /etc/hosts
echo "127.0.0.1 api.nerdlythinking.com" | sudo tee --append /etc/hosts

while [ ! -d /etc/nginx/conf.d ]
do
  sleep 10
  echo "waiting for provisioning files..."
done

sudo mv /tmp/conf.d/* /etc/nginx/conf.d

sudo apt-get update
sudo apt-get -y install apache2-utils # for htpasswd util
sudo htpasswd -c -b /etc/nginx/conf.d/.htpasswd nerdlythinking admin

sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -y python-certbot-nginx

# remove --dry-run flag for production
sudo certbot -n --dry-run --agree-tos --email elvishernandezdev@gmail.com \
--nginx -d phpmyadmin.nerdlythinking.com,\
directus.nerdlythinking.com,\
gatsby.nerdlythinking.com

sudo systemctl restart nginx