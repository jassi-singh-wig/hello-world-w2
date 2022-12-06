
resource "aws_instance" "ubuntu" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"
  count = 1

  user_data = "${file("script-ubuntu.sh")}"
  user_data_replace_on_change = true

  # key_name = "ubuntu"

  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "HelloWorld-ubuntu"
  }
}


output "instances-ubuntu" {
  value       = "${aws_instance.ubuntu.*.private_ip}"
  description = "PrivateIP address details of ubuntu instance"
}
