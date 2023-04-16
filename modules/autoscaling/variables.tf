variable "key_name" {
    type = string
    default = "rskey"
}
variable "image_id" {
    default = "ami-007855ac798b5175e"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "security_groups"{}
variable "subnet_id" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "lb_subnets" {}

