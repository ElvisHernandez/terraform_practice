#!/bin/bash

chmod 400 /home/ubuntu/.ssh/deploy*
chmod 600 /home/ubuntu/.ssh/config

su -c 'git clone git@gitlab.com:miami-dev-shop/boilerplates/gatsby-directus-jam-stack.git /home/ubuntu/gatsby-directus-jam-stack' ubuntu
cd /home/ubuntu/gatsby-directus-jam-stack

source /tmp/.env

mv /tmp/.env .

while [ ! $(command -v docker-compose) ]
do
  sleep 10
  echo "waiting for provisioning files..."
done

docker-compose up -d mysql directus;

sleep 20;

docker-compose run -T --rm directus install --email $DIRECTUS_ADMIN_EMAIL --password $DIRECTUS_ADMIN_PASSWORD;

# sleep 20;

TOKEN=$DIRECTUS_API_TOKEN

SQL="UPDATE directus_users SET token = '$TOKEN' WHERE email = '$DIRECTUS_ADMIN_EMAIL';";

docker-compose exec -T mysql mysql -u directus -D directus -pdirectus -e "$SQL";

# seed directus backend with necessary data for frontend
curl -X POST -H "Content-Type: application/json" \
-H "Authorization: bearer $TOKEN" \
-d @/home/ubuntu/gatsby-directus-jam-stack/seed/seo_image_collection.json 'http://localhost:8001/_/collections';

curl -X POST -H "Content-Type: application/json" \
-H "Authorization: bearer $TOKEN" \
-d @/home/ubuntu/gatsby-directus-jam-stack/seed/seo_image_item.json 'http://localhost:8001/_/items/seo_image';

curl -H "Authorization: bearer $TOKEN" \
-F "image=@/home/ubuntu/gatsby-directus-jam-stack/seed/seed.png" 'http://localhost:8001/_/files'

curl -X POST -H "Content-Type: application/json" \
-H "Authorization: bearer $TOKEN" \
-d @/home/ubuntu/gatsby-directus-jam-stack/seed/post_collection.json 'http://localhost:8001/_/collections';

curl -X POST -H "Content-Type: application/json" \
-H "Authorization: bearer $TOKEN" \
-d @/home/ubuntu/gatsby-directus-jam-stack/seed/post_item.json 'http://localhost:8001/_/items/post';

# env variables needed for gatsby container
# echo -e "DIRECTUS_API_TOKEN=$TOKEN" >> .env;
echo -e "DIRECTUS_URL=http://directus" >> .env;

docker-compose up -d;

sleep 5;

curl -X POST -H "Content-Type: application/json" \
-H "Authorization: bearer $TOKEN" \
-d @/home/ubuntu/gatsby-directus-jam-stack/seed/deployment_collection.json 'http://localhost:8001/_/collections';