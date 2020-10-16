#!/bin/bash

git clone git@gitlab.com:miami-dev-shop/boilerplates/gatsby-directus-jam-stack.git
cd gatsby-directus-jam-stack

while [ ! $(command -v docker-compose) ]
do
  sleep 10
  echo "waiting for provisioning files..."
done

sudo docker-compose up -d