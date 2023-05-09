resource "aws_kms_key" "dynamodb_encryption" {
  description         = "Customer managed KMS key for DynamoDB encryption"
  enable_key_rotation = true
}

resource "aws_dynamodb_table" "parsley" {
  name           = "parsley"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Parsley-1"
  range_key      = "Parsley-2"
#   read_capacity  = 1
#   write_capacity = 1
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_encryption.arn
  }

  attribute {
    name = "Parsley-1"
    type = "S"
  }

  attribute {
    name = "Parsley-2"
    type = "N"
  }

  tags = {
    "Access-Parsley-2" = "readonly"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_appautoscaling_target" "parsley_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = aws_dynamodb_table.parsley.arn
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "parsley_policy" {
  name               = "parsley_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_dynamodb_table.parsley.arn
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    scale_in_cooldown  = 30
    scale_out_cooldown = 30

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "dynamodb_policy"
  description = "IAM policy for DynamoDB table access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = aws_dynamodb_table.parsley.arn
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "dynamodb_policy_attachment" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group" "product_managers" {
  name = "product_managers"
}

resource "aws_iam_policy" "parsley_rw_policy" {
  name   = "parsley_rw_policy"
  policy = data.aws_iam_policy_document.parsley_rw_policy.json
}

data "aws_iam_policy_document" "parsley_rw_policy" {
  statement {
    actions   = ["dynamodb:*"]
    resources = [aws_dynamodb_table.parsley.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "parsley_ro_policy" {
  name = "parsley_ro_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = "${aws_dynamodb_table.parsley.arn}/index/Parsley-2-index"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "parsley_rw_policy_attachment" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.parsley_rw_policy.arn
}

resource "aws_iam_group_policy_attachment" "parsley_ro_policy_attachment" {
  group      = aws_iam_group.product_managers.name
  policy_arn = aws_iam_policy.parsley_ro_policy.arn
}

