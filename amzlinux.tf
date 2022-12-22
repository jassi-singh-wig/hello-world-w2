data "aws_ami" "awslinux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

data "template_cloudinit_config" "cloudinit_helloworld" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = templatefile("scripts/cloud-config.txt",{})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("scripts/filebeat.sh",
    {
      VERSION = "8.5.0-1"
    }
    )
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("scripts/logstash.sh",
    {
      VERSION = "8.5.0-1"
    }
    )
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("scripts/app.sh",{})
  }
  
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.awslinux.id 
  instance_type = "t3.small"
  count = 1

  # user_data = "${file("script.sh")}"
  user_data = base64encode(data.template_cloudinit_config.cloudinit_helloworld.rendered)
  user_data_replace_on_change = true

  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "HelloWorld"
  }
}


output "instances" {
  value       = "${aws_instance.web.*.public_ip}"
  description = "PublicIP address details"
}
