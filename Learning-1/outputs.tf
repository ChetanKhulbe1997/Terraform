output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.my_instance.private_ip
}

output "ec2_public_dns" {
  value = aws_instance.my_instance.public_dns
}





# "Outputs for Count [Metadata]"

/* output "ec2_public_ip" {
  value = aws_instance.my_instance[*].public_ip  # Here you are applying changes to single resource.
}

output "ec2_private_ip" {
  value = aws_instance.my_instance[*].private_ip  # Here [*] means, you are applying changes to multiple or all resources.
}

output "ec2_public_dns" {
  value = aws_instance.my_instance[*].public_dns
} */






# "Outputs For_each [Metadata]"

/* output "ec2_public_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.public_ip
  ]
}

output "ec2_private_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.private_ip
  ]
}

output "ec2_public_dns" {
  value = [
    for instance in aws_instance.my_instance : instance.public_dns
  ]
} */



# To comment out multiple syntaxes in 'VS Code' in one go, select the text and then use 'Shit + Alt + a' or 'Ctrl + /'

/* output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip          # Here you are applying changes to single resource.
}

output "ec2_private_ip" {
  value = aws_instance.my_instance[*].private_ip      # Here [*] means, you are applying changes to multiple or all resources.
} */