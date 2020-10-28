
module "src" {
	source = "./src"

  domain = var.domain
  gitlab_ci_cd_token = var.gitlab_ci_cd_token
  directus_api_token = var.directus_api_token
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "gitlab" {
    token = var.gitlab_token
}
