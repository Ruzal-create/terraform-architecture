# output "ec2_id" {
#       value = [aws_instance.ec2.id,aws_instance.ec2_2.id]
# }

output "security_group_id" {
      value = [aws_security_group.ec2-sg.id]
}

output "security_group_name" {
      value = aws_security_group.ec2-sg.name
}

output "image_id" {
      value = "ami-007855ac798b5175e"
}