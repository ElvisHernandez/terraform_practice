#!/bin/bash

# original working directory
OWD=$PWD

mkdir -p $PWD/private/gitlab

cd $PWD/private/gitlab

# call your key `deploy-key`
ssh-keygen -f deploy-key -P ""

echo "\
Host gitlab.com
    User git
    IdentityFile ~/.ssh/deploy-key
" > config

echo "\
gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
" > known_hosts

echo ""

cd $OWD

read -p "Enter domain name: " DOMAIN_NAME;
read -p "Enter gitlab access token: " GITLAB_ACCESS_TOKEN;
read -p "Enter gitlab ci/cd token: " GITLAB_CI_CD_TOKEN;
read -p "Enter nginx username: " NGINX_USERNAME;
read -p "Enter nginx password: " NGINX_PASSWORD;
read -p "Enter directus admin email: " DIRECTUS_ADMIN_EMAIL;
read -p "Enter directus admin password: " DIRECTUS_ADMIN_PASSWORD;

echo "TF_VAR_gitlab_access_token=$GITLAB_ACCESS_TOKEN" >> .env;
echo "TF_VAR_domain=$DOMAIN_NAME" >> .env;
echo "TF_VAR_gitlab_ci_cd_token=$GITLAB_CI_CD_TOKEN" >> .env;
echo "TF_VAR_nginx_username=$NGINX_USERNAME" >> .env;
echo "TF_VAR_nginx_password=$NGINX_PASSWORD" >> .env;
echo "TF_VAR_directus_admin_email=$DIRECTUS_ADMIN_EMAIL" >> .env;
echo "TF_VAR_directus_admin_password=$DIRECTUS_ADMIN_PASSWORD" >> .env;

$PWD/scripts/genDirectusToken.sh

sed -i  "s/domain/$DOMAIN_NAME/g" $PWD/nginx/conf.d/htpasswd;
sed -i  "s/domain/$DOMAIN_NAME/g" $PWD/nginx/conf.d/services.conf;