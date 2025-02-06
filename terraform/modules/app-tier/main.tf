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

  user_data = filebase64("${path.module}/example.sh")
}