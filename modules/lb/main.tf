//Create security group

//Register the EC2 instances with the target group
# resource "aws_lb_target_group_attachment" "my_target_group_attachment_1" {
#   target_group_arn = aws_lb_target_group.my_target_group.arn
#   target_id        = var.instance_id[0]
#   port             = 3000
# }

# resource "aws_lb_target_group_attachment" "my_target_group_attachment_2" {
#   target_group_arn = aws_lb_target_group.my_target_group.arn
#   target_id        = var.instance_id[1]
#   port             = 3000
# }


resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"

  subnets            = [var.subnet_id[0],var.subnet_id[1]]
  security_groups    = var.security_group

  tags = {
    Environment = "dev"
  }
}


//Target Group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_attachment" "rs_lb_attachment" {
  autoscaling_group_name = var.autoscaling_group_name
  lb_target_group_arn   = aws_lb_target_group.my_target_group.arn
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
