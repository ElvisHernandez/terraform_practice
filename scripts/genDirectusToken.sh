#!/bin/bash

IS_DEFINED=$(cat .env | grep TF_VAR_directus_api_token);
TOKEN=$(echo "$(date)" | md5sum | cut -c1-16)

if [ ! -z "$IS_DEFINED" ]
then
    sed -i  "s/TF_VAR_directus_api_token=.*/TF_VAR_directus_api_token=$TOKEN/g" .env;
else
    echo "TF_VAR_directus_api_token=$TOKEN" >> .env;
fi