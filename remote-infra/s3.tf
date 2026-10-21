resource "aws_s3_bucket" "remote-s3" {
  bucket = "remote-state-bucket-2501"

  tags = {
    Name = "remote-state-bucket-2501"
  }
}