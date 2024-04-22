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

resource "aws_secretsmanager_secret" "secret" {
  name                           = var.name
  description                    = var.description
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  kms_key_id                     = var.kms_key_id
  policy                         = var.policy
  recovery_window_in_days        = var.recovery_window_in_days

  dynamic "replica" {
    for_each = var.replica_region != null ? [1] : []

    content {
      kms_key_id = var.replica_kms_key_id
      region     = var.replica_region
    }
  }

  tags = local.tags
}
