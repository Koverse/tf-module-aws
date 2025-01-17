variable "public_key" {}
variable "image" {}
variable "disk" {}
variable "name" {}
variable "subnet" {}
variable "vpc_security_group_id" {}
variable "access_key" {}
variable "secret_key" {}
variable "region" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_key_pair" "instance_keypair" {
  key_name   = "${var.name}-keypair"
  public_key = "${var.public_key}"
}

resource "aws_instance" "instance" {
  ami           = "${var.image}"
  instance_type = "t2.xlarge"
  key_name = "${aws_key_pair.instance_keypair.key_name}"
  subnet_id = "${var.subnet}"
  vpc_security_group_ids = ["${var.vpc_security_group_id}"]
  associate_public_ip_address = true
  tags = {
    Name = "${var.name}"
    Owner = "hobbyfarm"
    DoNotDelete = "true"
  }
  root_block_device {
    volume_type = "standard"
    volume_size = "${var.disk}"
    delete_on_termination = true
  }
}

output "private_ip" {
  value = "${aws_instance.instance.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.instance.public_ip}"
}

output "hostname" {
  value = "${aws_instance.instance.public_dns}"
}
