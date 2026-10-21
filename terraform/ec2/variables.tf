variable "ec2_instance-type" {
    default = "t3.micro"
}

variable "ec2_default_root_storage_size" {
    default = 10
    type = number
}

variable "ec2_ami_id" {
    default = "ami-0e5497a77ef21b5ac"
}

variable "env" {
  default = "prd"
  type = string
}