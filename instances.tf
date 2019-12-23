resource "aws_instance" "nginx" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type = "ssh"
    user = "ec2-user"
    host = "${self.public_ip}"

    private_key = "${file("ssh/terraform.pem")}"
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
  provisioner "file" {
    source      = "docker/install.sh"
    destination = "/tmp/install.sh"
  }

  # copy our mysql_pre script to the remote host
  provisioner "file" {
    source      = "docker/nginx/docker-compose.yml"
    destination = "/tmp/docker-compose.yml"
  }

  # copy our mysql_pre script to the remote host
  provisioner "file" {
    source      = "docker/nginx/docker-entrypoint.sh"
    destination = "/tmp/docker-entrypoint.sh"
  }

  # copy our mysql_pre script to the remote host
  provisioner "file" {
    source      = "docker/nginx/Dockerfile"
    destination = "/tmp/Dockerfile"
  }

  # copy our mysql_pre script to the remote host
  provisioner "file" {
    source      = "docker/nginx/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install django, a simple app and start it. By default,
  # this should be on port 8000
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install.sh",
    ]
  }

  # install docker and friends
  provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/install.sh",
    ]
  }
}

resource "aws_instance" "django" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type = "ssh"
    host = "${self.public_ip}" 
    user = "ec2-user"

    private_key = "${file("ssh/terraform.pem")}"
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

  provisioner "file" {
    source      = "docker/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    source      = "docker/django/docker-compose.yml"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    source      = "docker/django/Dockerfile"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    source      = "docker/django/requirements.txt"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    source      = "docker/django/tinyapp.py"
    destination = "/tmp/install.sh"
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install django, a simple app and start it. By default,
  # this should be on port 8000
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install.sh",
    ]
  }

  # install docker and friends
  provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/install.sh",
    ]
  }
}

resource "aws_instance" "haproxy" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type = "ssh"
    host = "${self.public_ip}"
    user = "ec2-user"

    private_key = "${file("ssh/terraform.pem")}"
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

  # copy our install script
  provisioner "file" {
    source      = "haproxy/install.sh"
    destination = "/tmp/install.sh"
  }

  # copy our haproxy config to the remote host
  provisioner "file" {
    source      = "haproxy/haproxy.cfg"
    destination = "/tmp/haproxy.cfg"
  }

  # We run a remote provisioner on the instance after creating it.
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sh /tmp/install.sh",
    ]
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.haproxy.id}"
  vpc      = true
}

