resource "aws_iam_role" "ec2_role" {
  name               = "apt-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


# Minimal inline policy for CloudWatch logs and SSM
resource "aws_iam_policy" "ec2_policy" {
  name = "apt-ec2-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"], Resource = "*" },
      { Effect = "Allow", Action = ["ssm:GetParameter", "ssm:DescribeInstanceInformation", "ssm:SendCommand"], Resource = "*" }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "apt-ec2-profile"
  role = aws_iam_role.ec2_role.name
}