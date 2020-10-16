terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
    }
  }
  required_version = ">= 0.13"
}
