provider "aws" {
    region="ap-south-1"
    version="~> 2.46"
}

resource "aws_default_vpc" "veenavpc" {
  
}

resource "aws_security_group" "mysg" {
    name="mysecuritygroup01"
    vpc_id=aws_default_vpc.veenavpc.id

    ingress {
        from_port=80
        to_port=80
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]

    }

    ingress {
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]

    }

    egress {
        from_port=0
        to_port=0
        protocol=-1
        cidr_blocks=["0.0.0.0/0"]

    }   
}
resource "aws_instance" "myserver" {
    #ami                   = "ami-062f7200baf2fa504"
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "27NovVeena"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = tolist(data.aws_subnet_ids.default_subnets.ids)[0]
    

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo hi this webserver created from terraform | sudo tee /var/www/html/index.html"
    ]
    
  }
}