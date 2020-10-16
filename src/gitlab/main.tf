
resource "gitlab_deploy_key" "deploy_key" {
    project = local.gitlab_project_id
    title   = "deploy key"
    key     = file("${var.gitlab_ssh_credentials_path}/deploy-key.pub")
}
