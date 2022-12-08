resource "aws_instance" "web" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t3.small"
  count = 1

  user_data = "${file("script.sh")}"
  user_data_replace_on_change = true

#   key_name = "helloworld"

  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "HelloWorld"
  }
}


output "instances" {
  value       = "${aws_instance.web.*.public_ip}"
  description = "PrivateIP address details"
}