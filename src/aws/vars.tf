
locals {
    s3_origin_id = "mds_site"
    bucket_name = "test-southpointetech-y-r-u-gae"

    pem_file = {
        key_name = "jamstack_key"
        key_path = "./private/jamstack_key.pem"
    }
}

variable "gitlab_ssh_credentials_path" {}
variable "remote_gitlab_ssh_config_path" {}