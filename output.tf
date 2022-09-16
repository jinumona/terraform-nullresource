# vim output.tf

output "amazon-linux-latest" {
    
   value = data.aws_ami.amazon.image_id
}

output "public_ip" {
    value = aws_instance.webserver.public_ip
}
