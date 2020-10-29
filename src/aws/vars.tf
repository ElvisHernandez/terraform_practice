
locals {
    s3_origin_id = "mds_site"
    bucket_name = "test-southpointetech-y-r-u-gae"

    pem_file = {
        key_name = "aws"
        key_path = "./private/aws.pem"
    }
}

variable "gitlab_ssh_credentials_path" {}
variable "remote_gitlab_ssh_config_path" {}
variable "gitlab_ci_cd_token" {}
variable "domain" {}
variable "directus_api_token" {}
variable "nginx_username" {}
variable "nginx_password" {}
variable "directus_admin_email" {}
variable "directus_admin_password" {}

output "aws_bucket_name" {
    value = local.bucket_name
}