
resource "aws_instance" "midhun" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name        = "terraform-ansible-midhun"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}