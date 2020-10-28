
module "aws" {
    source = "./aws"

    domain = var.domain
    gitlab_ssh_credentials_path = var.gitlab_ssh_credentials_path
    remote_gitlab_ssh_config_path = var.remote_gitlab_ssh_config_path
    gitlab_ci_cd_token = var.gitlab_ci_cd_token
    directus_api_token = var.directus_api_token
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