resource "aws_key_pair" "my_test_key" {
  key_name = "${var.env}-terra-key-ec2-1"
  public_key = file("terra-key-ec2.pub")

  tags = {
    Environment = var.env
  }
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_security" {
  name = "${var.env}-infra-app-sg"
  description = "this will add a TF generate Security Group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
  }

  #outbound rules

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All Access open outbound"
  }

  tags = {
    name = "${var.env}-infra-app-sg"
  }
}


resource "aws_instance" "my_instance" {
  count = var.instance_count
  depends_on = [ aws_security_group.my_security, aws_key_pair.my_test_key ]

  key_name = aws_key_pair.my_test_key.key_name
  security_groups = [aws_security_group.my_security.name]
  instance_type = var.instance_type
  ami = var.ec2_ami_id

    root_block_device {
      volume_size = var.env == "prd" ? 10 : 8
      volume_type = "gp3"
    }

    tags = {
      Name = "${var.env}-infra-app-instance"
      Environment = var.env
    }
}