module "dev-infra" {
  source = "./infra-app"
  env = "dev"
  bucket_name = "test-infra-bucket-2501"
  instance_count = 1
  instance_type = "t3.micro"
  ec2_ami_id = "ami-0e5497a77ef21b5ac" #ubuntu
  hash_key = "studentID"

}