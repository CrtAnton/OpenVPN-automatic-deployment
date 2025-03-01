##############################
# Security Group             #
##############################


resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow SSH (22) and port 1194"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 1194"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############################
# EC2 Instance               #
##############################


resource "aws_instance" "openvpn-server" {
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t2.micro"  
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  source_dest_check      = false

  tags = {
    Name = "openvpn-server"
  }
  user_data = templatefile("${path.module}/instance-script.sh", {
  Root_Passphrase = var.Root_Passphrase
  Root_CA_Name = var.Root_CA_Name
})
}