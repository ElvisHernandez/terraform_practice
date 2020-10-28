
variable "gitlab_ssh_credentials_path" {
    default = "./private/gitlab"
}

variable "remote_gitlab_ssh_config_path" {
    default = "/home/ubuntu/.ssh"
}

variable "domain" {}
variable "gitlab_ci_cd_token" {}
variable "directus_api_token" {}
