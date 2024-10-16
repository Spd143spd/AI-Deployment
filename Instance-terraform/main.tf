resource "aws_security_group" "Jenkins-SG" {
  name        = "Jenkins-Security Group"
  description = "Open 22,443,80,8080,9000,9100,9090,3000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000,9100,9090,3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG-1"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-0595d6e81396a9efb"  #change your ami value according to your aws instance
  instance_type          = "t2.large"
  key_name               = "hemp.pem"
  vpc_security_group_ids = [aws_security_group.Jenkins-SG.id]
  user_data              = templatefile("./script.sh", {})

  tags = {
    Name = "AI"
  }
  root_block_device {
    volume_size = 30
  }
}
resource "aws_instance" "web2" {
  ami                    = "ami-0595d6e81396a9efb" #change your ami value according to your aws instance 
  instance_type          = "t2.medium"
  key_name               = "hemp.pem"
  vpc_security_group_ids = [aws_security_group.Jenkins-SG.id]
  tags = {
    Name = "Monitoring server"
  }
  root_block_device {
    volume_size = 30
  }
}
