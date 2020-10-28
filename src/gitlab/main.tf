
resource "gitlab_deploy_key" "deploy_key" {
    project = local.gitlab_project_id
    title   = "deploy key"
    key     = file("${var.gitlab_ssh_credentials_path}/deploy-key.pub")
}

data "gitlab_project" "default" {
    id = "20537198"
}

resource "gitlab_project_variable" "AWS_ACCESS_KEY_ID" {
    project = data.gitlab_project.default.id
    key = "AWS_ACCESS_KEY_ID"
    value = var.aws_key
}

resource "gitlab_project_variable" "AWS_SECRET_ACCESS_KEY" {
    project = data.gitlab_project.default.id
    key = "AWS_SECRET_ACCESS_KEY"
    value = var.aws_secret_key
}

resource "gitlab_project_variable" "AWS_BUCKET_NAME" {
    project = data.gitlab_project.default.id
    key = "AWS_BUCKET_NAME"
    value = var.aws_bucket_name
}

resource "gitlab_project_variable" "DIRECTUS_URL" {
    project = data.gitlab_project.default.id
    key = "DIRECTUS_URL"
    value = "http://api.${var.domain}"
}

resource "gitlab_project_variable" "DIRECTUS_API_TOKEN" {
    project = data.gitlab_project.default.id
    key = "DIRECTUS_API_TOKEN"
    value = var.directus_api_token
}