# Required Variables
variable "snowflake_account" {
  type      = string
  sensitive = true
}

# Optional Variables
variable "aws_region" {
  description = "The AWS region in which the AWS infrastructure is created."
  type = string
  default     = "us-west-2"
}

variable "prefix" {
  type        = string
  description = <<EOT
    This will be the prefix used to name the Resources.
    WARNING: Enter a short prefix in order to prevent name length related restrictions
  EOT
  default     = "example"
}

variable "env" {
  type        = string
  description = "Dev/Prod/Staging or any other custom environment name."
  default     = "dev"
}

variable "snowflake_integration_owner_role" {
  type    = string
  default = "ACCOUNTADMIN"
}

variable "snowflake_integration_user_roles" {
  type        = list(string)
  default     = []
  description = "List of roles to which GEFF infra will GRANT USAGE ON INTEGRATION perms."
}

variable "data_bucket_arns" {
  type        = list(string)
  default     = []
  description = "List of Bucket ARNs for the s3_reader role to read from."
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

locals {
  storage_prefix = "${var.prefix}_${var.env}"
}

locals {
  s3_reader_role_name     = "${local.storage_prefix}_s3_reader"
  s3_sns_policy_name      = "${local.storage_prefix}_s3_sns_topic_policy"
  s3_sns_topic_name       = "${local.storage_prefix}_bucket_sns"
}