# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "xxx"
  secret_key = "yyy"
  region = var.region
}

# IAM Lines taken from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/greet_lambda"
  retention_in_days = 14
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

# Defining aws_lambda_function

resource "aws_lambda_function" "lambda_function" {
  handler          = "greet_lambda.lambda_handler"
  runtime          = "python3.6"
  filename         = "greet_lambda.zip"
  function_name    = "greet_lambda"
  source_code_hash =  filebase64sha256("greet_lambda.zip")
  role             =  aws_iam_role.iam_for_lambda.arn

environment {
    variables = {
      greeting = "Hello"
    }
  }
}

