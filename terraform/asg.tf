data "template_file" "user_data" {
  template = file("../user-data.sh")
}


resource "aws_launch_template" "lt" {
  name_prefix   = "apt-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


resource "aws_autoscaling_group" "asg" {
  name                = "apt-asg"
  desired_capacity    = var.asg_desired
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns         = [aws_lb_target_group.tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 30

  tag {
    key                 = "Name"
    value               = "apt-private-ec2"
    propagate_at_launch = true
  }
}