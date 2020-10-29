
module "src" {
	source = "./src"

  domain = var.domain
  gitlab_ci_cd_token = var.gitlab_ci_cd_token
  directus_api_token = var.directus_api_token
  nginx_username = var.nginx_username
  nginx_password = var.nginx_password
  directus_admin_email = var.directus_admin_email
  directus_admin_password = var.directus_admin_password
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "gitlab" {
    token = var.gitlab_access_token
}
