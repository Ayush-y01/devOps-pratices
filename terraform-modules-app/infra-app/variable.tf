variable "env" {
  description = "This is environment for my infra"
  type = string
}

variable "bucket_name" {
  description = "This is bucket name for my infra"
  type = string
}

variable "ec2_ami_id" {
  description = "this is ec2 ami id "
  type = string
}

variable "instance_count" {
  description = "This is number of EC2 instance"
  type = number
}

variable "instance_type" {
  description = "This is intance type of EC2"
  type = string
  
}

variable "hash_key" {
  
}
