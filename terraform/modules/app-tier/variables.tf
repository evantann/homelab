variable project_name {
  description = "The project name"
}

variable app_sg_id {
  description = "The security group ID for the app tier"
}

variable aws_iam_instance_profile {
  description = "The IAM instance profile name for AmazonSSMManagedInstanceCore"
}

variable vpc_id {
  description = "The VPC ID"
}

variable internal_lb_sg_id {
  description = "The security group ID for the internal load balancer"
}

variable app_tier_subnet_ids {
  description = "The App Tier Subnets"
}