
module "aws" {
    source = "./aws"

    domain = var.domain
    gitlab_ssh_credentials_path = var.gitlab_ssh_credentials_path
    remote_gitlab_ssh_config_path = var.remote_gitlab_ssh_config_path
    gitlab_ci_cd_token = var.gitlab_ci_cd_token
    directus_api_token = var.directus_api_token

    nginx_username = var.nginx_username
    nginx_password = var.nginx_password
    directus_admin_email = var.directus_admin_email
    directus_admin_password = var.directus_admin_password
}

module "gitlab" {
    source = "./gitlab"

    gitlab_ssh_credentials_path = var.gitlab_ssh_credentials_path
    aws_key = module.aws.aws_key
    aws_secret_key = module.aws.aws_secret_key
    aws_bucket_name = module.aws.aws_bucket_name
    directus_api_token = var.directus_api_token
    domain = var.domain
}

output "aws_key" {
    value = module.aws.aws_key
}

output "aws_secret_key" {
    value = module.aws.aws_secret_key
}