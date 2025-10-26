variable "ec2_instance_type" {
  default = "t3.micro"
  type    = string
}


/* variable "ec2_root_storage_size" {
  default = 10
  type    = number
} */


variable "ec2_ami_id" {
  default = "ami-0b5317ee10bd261f7"
  type    = string

}




#Conditional expression variable
variable "env" {
  default = "Prod"
  type    = string
}


variable "ec2_root_default_storage_size" {
  default = 10
  type    = number
}