resource "aws_iam_role" "ssm-ec2-role" {
  name = "ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "EC2AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "ssm-ec2-role"
  }
}

# Best practice: use data sources to fetch policies dynamically to avoid hardcoded typos or errors
data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm-ec2-role-policy" {
  role       = aws_iam_role.ssm-ec2-role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_instance_profile" "ssm-instance-profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm-ec2-role.name
}