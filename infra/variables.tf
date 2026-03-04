variable "aws_region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "monthly_budget_limit" {
  default = 500
}

variable "default_tags" {
  type = map(string)
  default = {
    App        = "platform-takehome"
    Env        = "dev"
    Owner      = "your-name"
    CostCenter = "data-platform"
  }
}