# key pair (for login)
resource "aws_key_pair" "my_key" {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

# VPC & security Group
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security" {
    name = "automate-sg"
    description = "this will add a TF Generated Security Group"
    vpc_id = aws_default_vpc.default.id #this is called interpolation in terraform language

    # inbound rules 
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSh Open"
    }

    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP Open"
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Flask app"
    }

    # outbound rules

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # this is means in terraform is eqaul to all ports
        cidr_blocks = ["0.0.0.0/0"]
        description = "All access open outbound"
    }


    tags = {
      name = "automate-sg"
    }
}

# AWS instance


resource "aws_instance" "my_instance" {
    # this is meta argument
    # count = 2 # this meta argument

    for_each = tomap({
        tws-test-micro = "t3.micro",
        tws-test-large = "t3.small"
    }) # this is also meta argument

    depends_on = [ aws_security_group.my_security, aws_key_pair.my_key ]

    key_name = aws_key_pair.my_key.key_name
    security_groups = [ aws_security_group.my_security.name ]
    instance_type = each.value
    ami = var.ec2_ami_id

    user_data = file("install-ngnix.sh")

    root_block_device {
      volume_size = var.env  == "prd" ? 20 : var.ec2_default_root_storage_size
      volume_type = "gp3"
    }

    tags = {
      Name = each.key
      Environment = var.env
    }

}