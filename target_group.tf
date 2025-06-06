resource "aws_alb_target_group" "main" {
  count = (var.use_lb && var.deployment_controller == "ECS") ? 1 : 0
  #name = format("%s-%s", var.cluster_name, var.service_name)
  name   = substr(sha256(format("%s%s", var.service_name, var.cluster_name)), 0, 32)
  port   = var.service_port
  vpc_id = var.vpc_id

  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "10")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "10")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = lookup(var.service_healthcheck, "port", var.service_port)
  }

  lifecycle {
    create_before_destroy = false
  }

}