provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "github_oidc_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main", "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/develop"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.github_repo}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_trust.json
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name = "github-actions-policy"
  role = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions_permissions.json
}

data "aws_iam_policy_document" "github_actions_permissions" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "eks:DescribeCluster",
      "eks:UpdateClusterConfig",
      "iam:PassRole",
      "sts:AssumeRole"
    ]
    resources = ["*"]
  }
}
