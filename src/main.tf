
module "aws" {
    source = "./aws"

    gitlab_ssh_credentials_path = var.gitlab_ssh_credentials_path
    remote_gitlab_ssh_config_path = var.remote_gitlab_ssh_config_path
}

module "gitlab" {
    source = "./gitlab"

    gitlab_ssh_credentials_path = var.gitlab_ssh_credentials_path
}