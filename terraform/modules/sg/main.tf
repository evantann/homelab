# Internal Load Balancer Security Group

resource "aws_security_group" "external-lb" {
  name        = "external-lb"
  description = "Allow HTTP and HTTPS inbound traffic from anywhere for external load balancer"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "external-lb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "elb-http" {
    security_group_id = aws_security_group.external-lb.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_ipv4 = ["0.0.0.0/0"]
}

resource "aws_vpc_security_group_ingress_rule" "elb-https" {
    security_group_id = aws_security_group.external-lb.id
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_ipv4 = ["0.0.0.0/0"]
}

# Web Tier Security Group

resource "aws_security_group" "web-tier-sg" {
    name        = "web-tier-sg"
    description = "Allow HTTP and HTTPS inbound traffic from extnernal load balancer for web tier"
    vpc_id      = "${var.vpc_id}"
    
    tags = {
        Name = "web-tier-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "web-tier-http" {
    security_group_id = aws_security_group.web-tier-sg.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    referenced_security_group_id = aws_security_group.external-lb.id
}

resource "aws_vpc_security_group_ingress_rule" "web-tier-https" {
    security_group_id = aws_security_group.web-tier-sg.id
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    referenced_security_group_id = aws_security_group.external-lb.id
}

# Internal Load Balancer Security Group

resource "aws_security_group" "internal-lb" {
  name        = "internal-lb"
  description = "Allow HTTP and HTTPS inbound traffic from web server for internal load balancer"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "internal-lb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ilb-http" {
    security_group_id = aws_security_group.internal-lb.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    referenced_security_group_id = aws_security_group.web-tier-sg.id
}

resource "aws_vpc_security_group_ingress_rule" "ilb-https" {
    security_group_id = aws_security_group.internal-lb.id
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    referenced_security_group_id = aws_security_group.web-tier-sg.id
}

# Private App Subnet Security Group

resource "aws_vpc_security_group" "private-app-sg" {
  name        = "private-app-sg"
  description = "Allow HTTP and HTTPS inbound traffic from internal load balancer for private app subnet"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "private-app-sg"
  }
}