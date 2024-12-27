provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      real-time-data-server = "real-time-data-server"
    }
  }
}

resource "aws_ecs_cluster" "real-time-data-server-ecs-cluster" {
  name = "real-time-data-server-ecs-cluster"
}

resource "aws_ecs_service" "real-time-data-server-ecs-service-public" {
  name            = "real-time-data-server-ecs-service-public"
  cluster         = aws_ecs_cluster.real-time-data-server-ecs-cluster.id
  task_definition = aws_ecs_task_definition.real-time-data-server-ecs-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60

  network_configuration {
    subnets         = [aws_subnet.real-time-data-server-public-subnet-a.id, aws_subnet.real-time-data-server-public-subnet-b.id]
    security_groups = [aws_security_group.real-time-data-server-ecs-public-sg.id]
    assign_public_ip = true
  }

  # Load balancer section binds the service to the target group (unchanged)
  # in the case of an ecs service with public ip, there is no need to a attach the target group as the attaching is done by ip here
  load_balancer {
    target_group_arn = aws_lb_target_group.real-time-data-server-elb-tg.arn
    container_name   = "real-time-data-server"
    container_port   = 3000
  }
  
  depends_on = [aws_lb_listener.real-time-data-server-public-elb-listener]
}

# EC2 task definitions - machines where the docker containers will be deployed

resource "aws_ecs_task_definition" "real-time-data-server-ecs-task" {
  family                   = "real-time-data-server-ecs-task"
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 1024         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.real-time-data-server-ecsTaskExecutionRole.arn}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "real-time-data-server",
      "image": "${aws_ecr_repository.real_time_server_repo.repository_url}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.real-time-data-server-log-group.name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "real-time-data-server-ecs-task-logs"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "environment": [],
      "memory": 1024,
      "cpu": 256
    }
  ]
  DEFINITION
}

resource "aws_cloudwatch_log_group" "real-time-data-server-log-group" {
  name              = "/aws/real-time-data-server/logs"
  retention_in_days = 7

  tags = {
    Environment = "staging"
    Service     = "real-time-data-server"
  }
}

# Output log group ARNs (optional, helpful for reference)
output "log_group_arn" {
  value = aws_cloudwatch_log_group.real-time-data-server-log-group.arn
}

# VPC, Subnets, Security Groups

resource "aws_vpc" "real-time-data-server-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "real-time-data-server-public-subnet-a" {
  vpc_id     = aws_vpc.real-time-data-server-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "real-time-data-server-public-subnet-b" {
  vpc_id     = aws_vpc.real-time-data-server-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "real-time-data-server-internet-gateway" {
  vpc_id = aws_vpc.real-time-data-server-vpc.id
}

resource "aws_eip" "real-time-data-server-elastic-ip-a" {
  vpc = true
}

resource "aws_eip" "real-time-data-server-elastic-ip-b" {
  vpc = true
}

resource "aws_nat_gateway" "real-time-data-server-nat-gateway-a" {
  allocation_id = aws_eip.real-time-data-server-elastic-ip-a.id
  subnet_id     = aws_subnet.real-time-data-server-public-subnet-a.id
}

resource "aws_nat_gateway" "real-time-data-server-nat-gateway-b" {
  allocation_id = aws_eip.real-time-data-server-elastic-ip-b.id
  subnet_id     = aws_subnet.real-time-data-server-public-subnet-b.id
}

resource "aws_route_table" "real-time-data-server-public-route-table" {
  vpc_id = aws_vpc.real-time-data-server-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.real-time-data-server-internet-gateway.id
  }
}

resource "aws_route_table_association" "real-time-data-server-public-route-table-association-a" {
  subnet_id      = aws_subnet.real-time-data-server-public-subnet-a.id
  route_table_id = aws_route_table.real-time-data-server-public-route-table.id
}

resource "aws_route_table_association" "real-time-data-server-public-route-table-association-b" {
  subnet_id      = aws_subnet.real-time-data-server-public-subnet-b.id
  route_table_id = aws_route_table.real-time-data-server-public-route-table.id
}

resource "aws_security_group" "real-time-data-server-elb-sg" {
  name        = "real-time-data-server-elb-sg"
  description = "Allow inbound traffic for ELB"
  vpc_id      = aws_vpc.real-time-data-server-vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS ingress
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "real-time-data-server-ecs-public-sg" {
  name        = "real-time-data-server-ecs-public-sg"
  description = "Allow ECS to communicate with ELB"
  vpc_id      = aws_vpc.real-time-data-server-vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.real-time-data-server-elb-sg.id] # security group association - allows traffic from them
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balancer (in Public Subnet)

resource "aws_lb" "real-time-data-server-lb" {
  name               = "real-time-data-server-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.real-time-data-server-elb-sg.id]
  subnets            = [aws_subnet.real-time-data-server-public-subnet-a.id, aws_subnet.real-time-data-server-public-subnet-b.id]
}

output "public_load_balancer_dns_name" {
  value = aws_lb.real-time-data-server-lb.dns_name
}

resource "aws_lb_target_group" "real-time-data-server-elb-tg" {
  name     = "real-time-data-server-elb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.real-time-data-server-vpc.id
  target_type = "ip"  # "ip" or "instance". Fargate instances use IP to register with the load balancer

  health_check {
    path                = "/health-check"
    interval            = 90
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


resource "aws_lb_target_group" "real-time-data-server-elb-tg-sec" {
  name     = "real-time-data-server-elb-tg-sec"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.real-time-data-server-vpc.id
  target_type = "ip"  # "ip" or "instance". Fargate instances use IP to register with the load balancer

  health_check {
    path                = "/health-check"
    interval            = 90
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "real-time-data-server-public-elb-listener" {
  load_balancer_arn = aws_lb.real-time-data-server-lb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.real-time-data-server-elb-tg.arn
  }
}

resource "aws_lb_listener" "real-time-data-server-public-elb-listener-sec" {
  load_balancer_arn = aws_lb.real-time-data-server-lb.arn
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn = "arn:aws:acm:${var.aws_region}:631147605394:certificate/ea6aead1-a7d2-4909-9165-e6eeb3e2fe11"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.real-time-data-server-elb-tg-sec.arn
  }
}

resource "aws_lb_listener_rule" "real-time-data-server-lb-listener-rule" {
  listener_arn = aws_lb_listener.real-time-data-server-public-elb-listener.arn
  priority     = 100
  action {
    type               = "forward"
    target_group_arn   = aws_lb_target_group.real-time-data-server-elb-tg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_listener_rule" "real-time-data-server-lb-listener-rule-sec" {
  listener_arn = aws_lb_listener.real-time-data-server-public-elb-listener-sec.arn
  priority     = 100
  action {
    type               = "forward"
    target_group_arn   = aws_lb_target_group.real-time-data-server-elb-tg-sec.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# Domain and certificate setup

resource "aws_route53_zone" "real-time-data-server-route53-zone" {
  name         = "flowinc.studio"  # Change to your actual domain
}

# (!) The below is used to create a new certificate, instead of using existing ones
# DNS validation record for ACM SSL Certificate
# resource "aws_route53_record" "real-time-data-server-route53-record" {
#   name    = "real-time-data-server-route53-record"
#   type    = "A" # alias record type
#   zone_id = aws_route53_zone.real-time-data-server-route53-zone.zone_id

#   alias {
#     name = aws_lb.real-time-data-server-lb.dns_name
#     zone_id = aws_lb.real-time-data-server-lb.zone_id
#     evaluate_target_health = true
#   }
  
#   ttl     = 300
#   records = [aws_lb.real-time-data-server-lb]
# }

# # Request or Import an SSL certificate via ACM for your domain
# resource "aws_acm_certificate" "real-time-data-server-ssl-certificate" {
#   domain_name       = "flowinc.studio"    # Change to your domain
#   validation_method = "DNS"

#   subject_alternative_names = ["flowinc.studio"]  # Add alternative domains if needed

#   # Create a DNS validation record in Route53
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html
# In order for ACM to be able to validate a domain not registered/managed via aws route53,
# you need to manually enter CNAME records provided by ACM into your provider's database, usually through a website
# for real-time-data-server: https://account.squarespace.com/domains/managed/real-time-data-server.me/dns/dns-settings
# This is so that aws can certify that you own the domain for which you are requesting an SSL certificate
# resource "aws_acm_certificate_validation" "real-time-data-server-ssl-certificate-validation" {
#   certificate_arn = aws_acm_certificate.real-time-data-server-ssl-certificate.arn
#   validation_record_fqdns = [aws_route53_record.real-time-data-server-route53-record.fqdn]
# }


# IAM Role for ECS Task Execution

resource "aws_iam_role" "real-time-data-server-ecsTaskExecutionRole" {
  name               = "real-time-data-server-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}


# IAM Policy for ECS Task Execution Role
resource "aws_iam_policy" "real-time-data-server-ecsTaskExecutionPolicy" {
  name        = "real-time-data-server-ecsTaskExecutionPolicy"
  description = "Policy for ECS Tasks to interact with AWS Services"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeServices",
          "ecs:DescribeClusters"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "real-time-data-server-ecsTaskExecutionPolicy" {
  role       = aws_iam_role.real-time-data-server-ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.real-time-data-server-ecsTaskExecutionPolicy.arn
}

# Log Group for Backend App
resource "aws_cloudwatch_log_group" "real-time-data-server-api-log-group" {
  name              = "/aws/real-time-data-server-api/logs"
  retention_in_days = 7  # Customize as needed
}
