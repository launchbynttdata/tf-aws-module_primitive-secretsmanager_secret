// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.



variable "description" {
  description = "Description of the secret"
  type        = string
  default     = null
}


variable "kms_key_id" {
  description = "ARN or ID of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you need to reference a CMK in a different account, you can use only the key ARN. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named `aws/secretsmanager`). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  type        = string
  default     = null
}

variable "name" {
  description = "Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: `/_+=.@-`"
  type        = string
  default     = null
}

variable "policy" {
  description = "Valid JSON document representing a resource policy. Removing policy from your configuration or setting policy to null or an empty string (i.e., policy = \"\") will not delete the policy since it could have been set by aws_secretsmanager_secret_policy. To delete the policy, set it to `{}` (an empty JSON document). For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide: https://learn.hashicorp.com/terraform/aws/iam-policy"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 ? true : var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30
    error_message = "This value can be 0 to force deletion without recovery or range from 7 to 30 days."
  }
}

variable "replica_region" {
  description = "REgion for replicating the secret. If not provided, no replication will be performed (default)."
  type        = string
  default     = null
}

variable "replica_kms_key_id" {
  description = "ARN, Key ID, or Alias of the AWS KMS key within the region secret is replicated to. If one is not specified, then Secrets Manager defaults to using the AWS account's default KMS key (`aws/secretsmanager`) in the region or creates one for use if non-existent. Has no effect unless a `replica_region` is specified."
  type        = string
  default     = null
}

variable "force_overwrite_replica_secret" {
  description = "A boolean value to specify whether to overwrite a secret with the same name in the destination Region. Defaults to `false`, has no effect unless `replica_region` is specified."
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the resources created by the module."
}
