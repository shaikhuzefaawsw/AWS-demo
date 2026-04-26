variable "project_name" { type = string }
variable "environment"  { type = string }
variable "tags"         { type = map(string) }

# GitHub repository configuration (optional)
variable "github_token" {
  description = "GitHub personal access token for repository access"
  type        = string
  default     = ""
  sensitive   = true
}

variable "github_repo" {
  description = "GitHub repository URL (e.g., https://github.com/username/repo)"
  type        = string
  default     = ""
}

variable "github_branch" {
  description = "GitHub branch to deploy from"
  type        = string
  default     = "main"
}
