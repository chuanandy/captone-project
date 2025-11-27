provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "api_staging" {
  name = "api-staging"
}

resource "aws_ecr_repository" "api_prod" {
  name = "api-prod"
}
