## inputs
## - environment_name

resource "aws_lb" "tas" {
  name = "${var.environment_name}-tas-lb"
  load_balancer_type = "network"
  internal = true
  enable_cross_zone_load_balancing = true
  subnets = [data.aws_subnet.elb-a.id,data.aws_subnet.elb-b.id,data.aws_subnet.elb-c.id]
}

resource "aws_lb_target_group" "web-443" {
  name = "${var.environment_name}-web-443-tg"
  port = 443
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "web-443" {
  load_balancer_arn = aws_lb.tas.arn
  port = 443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }
}

resource "aws_lb_target_group" "web-80" {
  name = "${var.environment_name}-web-80-tg"
  port = 80
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "web-80" {
  load_balancer_arn = aws_lb.tas.arn
  port = 443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-80.arn
  }
}

resource "aws_lb_target_group" "ssh-2222" {
  name = "${var.environment_name}-ssh-2222-tg"
  port = 2222
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "ssh-2222" {
  load_balancer_arn = aws_lb.tas.arn
  port = 2222
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ssh-2222.arn
  }
}

locals {
  tcp_port_count = 5
}

resource "aws_lb_target_group" "tcprouter" {
  name     = "${var.environment_name}-tcprouter-${1024 + count.index}-tg"
  port     = 1024 + count.index
  protocol = "TCP"
  vpc_id   = data.aws_vpc.foundation.id

  count = local.tcp_port_count

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "tcprouter" {
  load_balancer_arn = aws_lb.tas.arn
  port              = 1024 + count.index
  protocol          = "TCP"

  count = local.tcp_port_count

  default_action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.tcprouter[*].arn, count.index)
  }
}

## output
## - tas_lb_external_fqdn = aws_lb.tas.dns_name
## - tas_router_https_target_group_name = aws_lb_target_group.web-443.name
## - tas_router_http_target_group_name = aws_lb_target_group.web-80.name
## - tas_sshproxy_target_group_name = aws_lb_target_group.ssh-2222.name
## - tas_tcp_target_group_name = aws_lb_target_group.tcprouter.name
