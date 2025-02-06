output db_sg_id {
  value = [aws_security_group.db-sg.id]
}

output app_sg_id {
  value = [aws_security_group.app-tier-sg.id]
}

output web_sg_id {
  value = [aws_security_group.web-tier-sg.id]
}

output internal_lb_sg_id {
  value = [aws_security_group.internal-lb.id]
}

output external_lb_sg_id {
  value = [aws_security_group.external-lb.id]
}