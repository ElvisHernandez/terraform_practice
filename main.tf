
module "src" {
	source = "./src"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "gitlab" {
    token = var.gitlab_token
}
