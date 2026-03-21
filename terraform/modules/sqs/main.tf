resource "aws_sqs_queue" "sqs_tech_challenge" {
  name                      = var.sqs_name
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds

  tags = {
    name = var.sqs_name
  }
}

data "aws_iam_policy_document" "data_sqs_policy" {
  statement {
    sid    = "__owner_statement"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["730335515098"]
    }

    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.sqs_tech_challenge.arn]
  }
depends_on = [ aws_sqs_queue.sqs_tech_challenge ]
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.sqs_tech_challenge.id
  policy    = data.aws_iam_policy_document.data_sqs_policy.json

depends_on = [ aws_sqs_queue.sqs_tech_challenge ]
}