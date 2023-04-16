//Create launch template
resource "aws_launch_template" "rs_template" {
  name  = "rs-template"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = filebase64("${path.module}/ec2-init.sh")
  network_interfaces {
    security_groups = var.security_groups
  }
}

resource "aws_autoscaling_group" "rs-autoscaling" {
  name = "rs-autoscaling"
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  health_check_grace_period = 300
  vpc_zone_identifier = [var.subnet_id[0],var.subnet_id[1]]

  launch_template {
    id      = aws_launch_template.rs_template.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
}


//scale up policy
resource "aws_autoscaling_policy" "rs-scaleup" {
  name                   = "rs-scaleup"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.rs-autoscaling.name
}

//scale up alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "rs-scaleup-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.rs-autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.rs-scaleup.arn]
}


//scale down policy
resource "aws_autoscaling_policy" "rs-scaledown" {
  name                   = "rs-scaleup"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.rs-autoscaling.name
}

//scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "rs-scaleup-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.rs-autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.rs-scaledown.arn]
}