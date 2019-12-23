resource "aws_instance" "nginx" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type = "ssh"
    user = "ec2-user"

    private_key = "${file("terraform.pem")}"
    timeout = "5m"
    agent = false
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"

  private_ip = "10.0.1.100"

  tags = {
    Name = "nginx"
  }

  # copy our mysql_pre script to the remote host 
  #provisioner "file" {
  #  source      = "docker/install.sh"
  #  destination = "/tmp/install.sh"
  #}

  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo apt-get -y update",
  #    "sudo apt-get -y install nginx",
  #    "sudo service nginx start",
  #  ]
  #}
}

resource "aws_instance" "django" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type = "ssh"
    user = "ec2-user"

    private_key = "${file("terraform.pem")}"
    timeout = "5m"
    agent = false
    # The connection will use the local SSH agent for authentication.
  }

  #instance_type = "m1.small"
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  private_ip = "10.0.1.101"

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Name = "django"
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo chmod +x /tmp/mysql_pre.sh",
  #    "sudo chmod +x /tmp/mysql_post.sh",
  #    "sudo chmod +x /tmp/mysql_wp_setup.sh",
  #  ]
  #}

  # Answer yes
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo sh /tmp/mysql_pre.sh",
  #  ]
  #}

  # Install mysql
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo apt-get -y update",
  #    "sudo apt-get install -y mysql-server",
  #  ]
  #}

  # Setup mysql
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo sh /tmp/mysql_post.sh",
  #    "sudo ufw allow 3306",
  #  ]
  #}

  # provision WP db
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo sh /tmp/mysql_wp_setup.sh",
  #  ]
  #}

}

resource "aws_instance" "haproxy" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type = "ssh"
    user = "ec2-user"

    private_key = "${file("terraform.pem")}"
    timeout = "5m"
    agent = false
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  #vpc_security_group_ids = "${aws_security_group.haproxy}"

  #security_groups = ["${aws_security_group.haproxy.id}"]
  vpc_security_group_ids = ["${aws_security_group.haproxy.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Name = "HAProxy"
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo apt-get -y update",
  #    "sudo apt-get install -y haproxy",
  #  ]
  #}
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.haproxy.id}"
  vpc      = true
}

