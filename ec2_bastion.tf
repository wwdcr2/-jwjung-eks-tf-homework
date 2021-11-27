resource "aws_security_group" "bastion_sg" {
  name = "${var.project}-sg-ec2-bastion"
  description = "Allow incoming HTTP connections"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ec2_key" {
    default = ""
}

resource "aws_instance" "bastion" {
  ami = "ami-003ef1c0e2776ea27"
  instance_type = "t3.small"
  subnet_id = module.subnets["pub"].subnet_ids.0
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name = "${var.project}-ec2-bastion"
  }
  #user_data = file("userdata_k8s.sh")
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.project}-role-ec2ssm"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.project}-role-ec2ssm"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_profile" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}