variable "ami_id" {
  type = string
  default = "ami-007855ac798b5175e"
  description = "AMI ID to deploy EC2 instance."
}

variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "Type of instance to deploy"
}

variable "vpc_id" {
  type = string
  default = "vpc-0d680165c0030b7a9"
  description = "VPC where we will create EC2 instance"
}

variable "name" {
  type = string
  default = "rujwal_demo"
}

variable "tags" {
  default = {}
  type = map(string)
  description = "A map of tags to add all resources"
}

variable "subnet_id" {
    default = "subnet-09682d2344e8819e0"
    # default = "subnet-09a1331e66bf6f46a"
    type = string
    description = "Subnet ID"  
}
