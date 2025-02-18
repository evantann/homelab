resource "aws_lb_target_group" "data-tier-tg" {
  name     = "data-tier-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/items"
  }
}

resource "aws_lb" "internal-lb" {
  name               = "internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.internal_lb_sg_id
  subnets            = var.app_tier_subnet_ids

  tags = {
    Name = "${var.project_name}-internal-lb"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.internal-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_launch_template" "app-tier" {
  name = "app-tier-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 10
    }
  }

  iam_instance_profile {
    name = var.aws_iam_instance_profile
  }

  image_id = "ami-0005ee01bca55ab66"

  instance_type = "t2.micro"

  vpc_security_group_ids = var.app_sg_id

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${project_name}-app-tier"
    }
  }

  user_data = filebase64("./modules/app-tier/example.sh")
}