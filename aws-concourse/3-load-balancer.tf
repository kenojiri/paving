## inputs
## - environment_name

resource "aws_lb" "concourse" {
  name = "${var.environment_name}-concourse-lb"
  load_balancer_type = "network"
  internal = true
  enable_cross_zone_load_balancing = true
  subnets = data.aws_subnet.concourse[*].id
}

resource "aws_lb_target_group" "web-443" {
  name = "${var.environment_name}-web-443-tg"
  port = 443
  protocol = "TCP"
  vpc_id = data.aws_vpc.concourse.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "web-443" {
  load_balancer_arn = aws_lb.concourse.arn
  port = 443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }
}

resource "aws_lb_target_group" "tcp-2222" {
  name = "${var.environment_name}-tcp-2222-tg"
  port = 443
  protocol = "TCP"
  vpc_id = data.aws_vpc.concourse.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "tcp-2222" {
  load_balancer_arn = aws_lb.concourse.arn
  port = 2222
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tcp-2222.arn
  }
}

## output
## - concourse_lb_external_fqdn = aws_lb.concourse.dns_name
