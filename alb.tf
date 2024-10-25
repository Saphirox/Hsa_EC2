resource "aws_lb" "hsa_alb" {
  name               = "hsa-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.hsa_sg.id]
  subnets            = [aws_subnet.hsa_subnet_1.id, aws_subnet.hsa_subnet_2.id]

  tags = {
    Name = "hsa"
  }
}

resource "aws_lb_target_group" "hsa_tg" {
  name     = "hsa-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.hsa_vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 15
    matcher            = "200,403,404"
    path               = "/index.html"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "hsa"
  }
}

resource "aws_lb_target_group_attachment" "hsa_attachment_1" {
  target_group_arn = aws_lb_target_group.hsa_tg.arn
  target_id        = aws_instance.ec2_test1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "hsa_attachment_2" {
  target_group_arn = aws_lb_target_group.hsa_tg.arn
  target_id        = aws_instance.ec2_test2.id
  port             = 80
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.hsa_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hsa_tg.arn
  }
}

output "ec2_test1_public_ip" {
   value = aws_lb.hsa_alb.dns_name
}