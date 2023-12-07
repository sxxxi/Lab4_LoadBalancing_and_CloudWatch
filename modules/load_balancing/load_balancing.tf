# Load Balancer
resource "aws_lb" "alb" {
  name = "L3ALB"
  load_balancer_type = "application"
  subnets = var.alb_subnet_ids
  security_groups = var.alb_sg_ids
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Create target group
resource "aws_lb_target_group" "target_group" {
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  #  target_type = "alb"
  health_check {
    enabled = true
    protocol = "HTTP"
    matcher = 200
    path = "/"
    interval = 10
    timeout = 5
    unhealthy_threshold = 3
  }
  tags = merge(var.default_tags, tomap({
    Name = "ALB Target Group"
  }))
}

resource "aws_autoscaling_group" "asg" {
  name = "WebASG"
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity   = 3
  max_size           = 6
  min_size           = 3

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "ASGScaleInPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "ASGScaleOutPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# Attach the policy to a cloud watch alarm
resource "aws_cloudwatch_metric_alarm" "ten_percent_alarm" {
  alarm_name          = "TenPercentAlarm"
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold = 10
  period = 30
  evaluation_periods  = 2
  actions_enabled = true
  ok_actions = [aws_autoscaling_policy.scale_in_policy.arn]
  alarm_actions = [aws_autoscaling_policy.scale_out_policy.arn]
  tags = merge(var.default_tags)
}


# Attach ASG to the target group
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.target_group.arn
}

# Attach instance profile to access S3
resource "aws_iam_instance_profile" "lab_profile" {
  name = "lab_profile"
  role = "LabRole"
}

# Create ASG
resource "aws_launch_template" "launch_template" {
  name_prefix   = "Web_"
  image_id      = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  iam_instance_profile {
    name = aws_iam_instance_profile.lab_profile.name
  }
  key_name = var.key_name
  vpc_security_group_ids = var.launch_template_sg_ids
  user_data = filebase64("${path.module}/../../scripts/web_user_data.sh")
  tags = merge(var.default_tags, tomap({
    Name = "L4 Launch Template"
  }))
}
