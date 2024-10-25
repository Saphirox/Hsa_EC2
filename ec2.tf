
resource "aws_instance" "ec2_test1" {
  ami = "ami-02801556a781a4499"
  instance_type = "t4g.nano"
  key_name = "saphirox"
  subnet_id = aws_subnet.hsa_subnet_1.id
  vpc_security_group_ids = [aws_security_group.hsa_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo -i
              yum update -y
              yum install -y httpd
              touch /var/www/html/index.html
              echo "EC1" >> /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "hsa"
  }
}

resource "aws_instance" "ec2_test2" {
  ami = "ami-02801556a781a4499"
  instance_type = "t4g.nano"
  key_name = "saphirox"
  subnet_id = aws_subnet.hsa_subnet_1.id
  vpc_security_group_ids = [aws_security_group.hsa_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo -i
              yum update -y
              yum install -y httpd
              touch /var/www/html/index.html
              echo "EC2" >> /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "hsa"
  }
}