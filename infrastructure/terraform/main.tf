# provider "aws" {
#   region = "eu-west-1"
# }

# # resource "aws_instance" "real_time_server" {
# #   ami           = var.ami_id
# #   instance_type = var.instance_type
# #   subnet_id     = aws_subnet.public.id
# #   associate_public_ip_address = true

# #   # key_name = aws_key_pair.real_time_server_key.key_name

# #   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

# #   user_data = <<-EOF
# #               #!/bin/bash
# #               yum update -yt
# #               yum install -y docker

# #               # Start and enable Docker service
# #               systemctl start docker
# #               systemctl enable docker

# #               # Authenticate Docker with ECR
# #               aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com

# #               # Stop and remove the old container if it exists
# #               docker stop real_time_server || true
# #               docker rm real_time_server || true

# #               # Pull the latest Docker image from ECR
# #               docker pull ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.real_time_server_repo.name}:latest

# #               # Run the new container
# #               docker run -d -dp 80:80 --name real_time_server ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/real_time_server:latest
# #               EOF

# #   tags = {
# #     Name = "real_time_server"
# #   }

# #   # security_groups = [aws_security_group.real_time_server_sg.id]
# #   vpc_security_group_ids = [ aws_security_group.real_time_server_sg.id ]
# # }


# # resource "aws_security_group" "real_time_server_sg" {
# #   name        = "real_time_server_sg"
# #   description = "Allow inbound traffic for the server"
# #   vpc_id = aws_vpc.main.id

# #   ingress {
# #     from_port   = 3000
# #     to_port     = 3000
# #     protocol    = "tcp"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   ingress {
# #     from_port   = 443
# #     to_port     = 443
# #     protocol    = "tcp"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   ingress {
# #     from_port   = 22
# #     to_port     = 22
# #     protocol    = "tcp"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   egress {
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }
# # }

# resource "aws_instance" "realtime_data_webapp" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   # subnet_id     = aws_subnet.public.id

#   associate_public_ip_address = true

#   # iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -yt
              
#               # Install Docker
#               sudo yum update -y
#               sudo yum install -y polkit
#               sudo yum install -y docker
#               sudo systemctl start docker
#               sudo systemctl enable docker
#               sudo usermod -aG docker ec2-user

#               # Authenticate Docker with ECR
#               aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com

#               # Stop and remove the old container if it exists
#               docker stop realtime_data_webapp || true
#               docker rm realtime_data_webapp || true

#               # Pull the latest Docker image from ECR
#               docker pull ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.realtime_data_webapp_repo.name}:latest

#               # Run the new container
#               docker run -d -dp 80:80 --name realtime_data_webapp ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.realtime_data_webapp_repo.name}:latest
#               EOF

#   tags = {
#     Name = "realtime_data_webapp"
#   }

#   # security_groups = [aws_security_group.realtime_data_webapp_sg.id]
#   vpc_security_group_ids = [aws_security_group.realtime_data_webapp_sg.id]
# }

# # Security Group Configuration for Next.js App
# resource "aws_security_group" "realtime_data_webapp_sg" {
#   name        = "realtime_data_webapp_sg"
#   description = "Allow inbound traffic for the web app"
#   # vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # # Logging Configuration

# # resource "aws_cloudwatch_log_group" "real_time_server_log_group" {
# #   name = "real_time_server_log_group"
# #   retention_in_days = 7

# #   tags = {
# #     Service     = "real_time_server"
# #   }
# # }

# # resource "aws_cloudwatch_log_group" "realtime_data_webapp_log_group" {
# #   name = "realtime_data_webapp_log_group"
# #   retention_in_days = 7

# #   tags = {
# #     "service" = "realtime_data_webapp"
# #   }
# # }

# # resource "aws_iam_role_policy" "cloudwatch_policy" {
# #   name   = "cloudwatch-logs-policy"
# #   role   = aws_iam_role.ec2_instance_role.id

# #   policy = <<EOF
# # {
# #   "Version": "2012-10-17",
# #   "Statement": [
# #     {
# #       "Effect": "Allow",
# #       "Action": [
# #         "logs:CreateLogGroup",
# #         "logs:CreateLogStream",
# #         "logs:PutLogEvents"
# #       ],
# #       "Resource": "arn:aws:logs:*:*:*"
# #     }
# #   ]
# # }
# # EOF
# # }

# # # Instance Profile

# # resource "aws_iam_role" "ec2_instance_role" {
# #   name = "ec2_instance_role"

# #   assume_role_policy = <<EOF
# #     {
# #       "Version": "2012-10-17",
# #       "Statement": [
# #         {
# #           "Action": "sts:AssumeRole",
# #           "Principal": {
# #             "Service": "ec2.amazonaws.com"
# #           },
# #           "Effect": "Allow",
# #           "Sid": ""
# #         }
# #       ]
# #     }
# #     EOF
# # }

# # resource "aws_iam_instance_profile" "ec2_instance_profile" {
# #   name = "cloudwatch-instance-profile"
# #   role = aws_iam_role.ec2_instance_role.name
# # }

# # resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
# #   role       = aws_iam_role.ec2_instance_role.name
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# # }
