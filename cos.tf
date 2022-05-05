resource "github_repository" "repo" {
  name                   = var.repo_name
  description            = var.description
  visibility             = var.visibility
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  is_template            = false
  has_issues             = var.has_issues
  delete_branch_on_merge = var.delete_branch_on_merge
  topics                 = var.topics
  has_downloads          = var.has_downloads
  vulnerability_alerts   = var.vulnerability_alerts

  dynamic "template" {
    for_each = var.template_repo_name == "" ? [] : [var.template_repo_name]
    content {
      owner      = var.gh_org
      repository = template.value
    }
  }
}

resource "github_branch_protection" "branch_protection" {
  repository_id  = github_repository.repo.node_id
  pattern        = "main"
  enforce_admins = var.enforce_admins
  required_status_checks {
    strict   = true
    contexts = var.status_checks
  }
  required_pull_request_reviews {
    dismiss_stale_reviews      = false
    require_code_owner_reviews = var.require_code_owner_reviews
  }
  required_linear_history         = var.required_linear_history
  require_conversation_resolution = var.require_conversation_resolution
  push_restrictions               = var.push_restrictions
  allows_deletions                = var.allows_deletions
  allows_force_pushes             = var.allows_force_pushes
}
