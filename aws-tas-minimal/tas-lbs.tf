resource "aws_lb" "tas" {
  name                             = "${var.environment_name}-tas-lb"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = false
  subnets                          = aws_subnet.public-subnet.subnet_id
}

resource "aws_lb_listener" "web-80" {
  load_balancer_arn = aws_lb.tas.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-80.arn
  }
}

resource "aws_lb_listener" "web-443" {
  load_balancer_arn = aws_lb.tas.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }
}

resource "aws_lb_listener" "ssh-2222" {
  load_balancer_arn = aws_lb.tas.arn
  port              = 2222
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh-2222.arn
  }
}

resource "aws_lb_target_group" "web-80" {
  name     = "${var.environment_name}-web-tg-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "web-443" {
  name     = "${var.environment_name}-web-tg-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "ssh-2222" {
  name     = "${var.environment_name}-ssh-tg"
  port     = 2222
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    protocol = "TCP"
  }
}
