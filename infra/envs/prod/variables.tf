variable name {
  type        = string
  description = "Project name prefix"
}

variable "region" {
    description = "AWS region"
    type = string
}

variable "azs" {
    description = "Availability zones"
    type = list(string)
}

variable "github_owner" {
    description = "Github organization or username for OIDC"
    type = string
}

variable "github_repo" {
    description = "Github repository for OIDC"
    type = string
}
