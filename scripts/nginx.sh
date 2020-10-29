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

while [ ! -f /tmp/.env ]
do
  sleep 10
  echo "waiting for provisioning files..."
done

source /tmp/.env

sudo mv /tmp/conf.d/* /etc/nginx/conf.d

sudo apt-get update
sudo apt-get -y install apache2-utils # for htpasswd util
sudo htpasswd -c -b /etc/nginx/conf.d/.htpasswd $NGINX_USERNAME $NGINX_PASSWORD

sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -y python-certbot-nginx

# add --dry-run flag for development and remove --dry-run flag for production
sudo certbot -n --agree-tos --email $DIRECTUS_ADMIN_EMAIL \
--nginx -d phpmyadmin.$DOMAIN,\
directus.$DOMAIN,\
gatsby.$DOMAIN

sudo systemctl restart nginx