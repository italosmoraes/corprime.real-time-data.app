# resource "aws_iam_role" "cloudwatch_role" {
#   name = "cloudwatch-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy" "cloudwatch_custom_policy" {
#   name        = "CloudWatchCustomPolicy"
#   description = "Custom policy for CloudWatch access"
#   policy      = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = [
#           "cloudwatch:PutMetricData",
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#           "logs:DescribeLogStreams"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "cloudwatch_custom_policy_attach" {
#   name       = "cloudwatch-custom-policy-attach"
#   roles      = [aws_iam_role.cloudwatch_role.name]
#   policy_arn = aws_iam_policy.cloudwatch_custom_policy.arn
# }


# resource "aws_iam_policy_attachment" "ssm_managed_instance_attach" {
#   name       = "ssm-managed-instance-attach"
#   roles      = [aws_iam_role.cloudwatch_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }


# resource "aws_iam_policy_attachment" "cloudwatch_logs_attach" {
#   name       = "cloudwatch-logs-attach"
#   roles      = [aws_iam_role.cloudwatch_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
# }

# resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
#   name = "cloudwatch-instance-profile"
#   role = aws_iam_role.cloudwatch_role.name
# }

# resource "aws_cloudwatch_log_group" "react_app_logs" {
#   name              = "/react-app/logs"
#   retention_in_days = 7
# }

# resource "aws_instance" "react_app" {
#   ami           = "ami-009452531fa1056fa" # Amazon Linux 2 AMI
#   instance_type = "t2.micro"
# #   key_name      = "<your-key-pair-name>"
#   security_groups = [aws_security_group.react_app_sg.name]

#   iam_instance_profile = aws_iam_instance_profile.cloudwatch_instance_profile.name

#   user_data = <<-EOF
#             #!/bin/bash

#             yum update -y

#             npm install -g serve
#             serve -s build

#             # Install SSM Agent
#             yum install -y amazon-ssm-agent
#             systemctl enable amazon-ssm-agent
#             systemctl start amazon-ssm-agent

#             # Install Node.js and CloudWatch Agent
#             curl -sL https://rpm.nodesource.com/setup_16.x | bash -
#             yum install -y nodejs git amazon-cloudwatch-agent
#             npm install -g create-react-app serve

#             # Create a React app
#             mkdir -p /var/www/react-app
#             cd /var/www/react-app
#             npx create-react-app my-app
#             cd my-app
#             npm run build

#             # Serve the React app
#             npm run start
#           EOF

#   tags = {
#     Name = "ReactAppInstance"
#   }
# }

# resource "aws_security_group" "react_app_sg" {
#   name        = "react-app-sg"
#   description = "Allow HTTP and SSH traffic"

#   ingress {
#     description = "Allow HTTP traffic"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow SSH traffic"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
