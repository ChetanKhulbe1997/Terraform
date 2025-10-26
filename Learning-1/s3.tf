# Resource block
resource "aws_s3_bucket" "my-first-bucket" {
  #args
  bucket = "mkr-free-devops-bootcamp"
  tags = {
    Name = "mkr-free-devops-bootcamp"
  }
}


#resource "aws_s3_bucket" "my-second-bucket" {
#args
#bucket = "mkr-free-devops-bootcamp"
#tags = {
#Name = "mkr-free-devops-bootcamp"
#}
#}


#resource "aws_s3_bucket" "my-third-bucket" {
#args
#bucket = "mkr-free-devops-bootcamp"
#tags = {
#Name = "mkr-free-devops-bootcamp"
#}
#}