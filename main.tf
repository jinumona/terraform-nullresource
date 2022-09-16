# vim main.tf

# Creating keyPair
# --------------------------------------------------------------

resource "aws_key_pair" "key" {
    
    key_name   = "${var.project}-${var.env}"
    public_key = file("localkey.pub")
   tags = {
      
       Name = "${var.project}-${var.env}"
       project = var.project
       env = var.env
  }
}


# instance  creation

resource "aws_instance" "webserver" {
  ami           = data.aws_ami.amazon.image_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids = ["sg-04182bdfbfa17d831"]
  tags = {
    Name = "webserver-${var.project}-${var.env}"
    project= var.project
      env = var.env
    
  }
}


# null resource

resource "null_resource" "sample" { 

    
     
    provisioner "file" {
        
      source      = "apache-install.sh"
      destination = "/tmp/apache-install.sh"

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./localkey")
        host        = aws_instance.webserver.public_ip
       }
        
    }
    
    provisioner "remote-exec" {
        
    inline = [
      "sudo chmod +x /tmp/apache-install.sh",
      "sudo /tmp/apache-install.sh"
    ]
        
    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./localkey")
        host        = aws_instance.webserver.public_ip
      }
   }
    
 triggers = {
   userdata_has = sha256(file("apache-install.sh"))
  }
    
}

