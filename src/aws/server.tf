
resource "aws_security_group" "allow_ssh" {
    description = "Allow ssh connections"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "server" {
    ami           = "ami-038e35de01603d84e"
    instance_type = "t3.micro"
    key_name = local.pem_file["key_name"]
    security_groups = [aws_security_group.allow_ssh.name]
    user_data = file("./scripts/setup.sh")
}

resource "null_resource" "init_server" {

    depends_on = [aws_instance.server]

    connection {
		host = aws_instance.server.public_ip
		type = "ssh"
		user = "ubuntu"
		agent = "true"
		private_key = file(local.pem_file["key_path"])
    }

	provisioner "file" {
		source = "${var.gitlab_ssh_credentials_path}/"
		destination = "${var.remote_gitlab_ssh_config_path}/"
	}

    provisioner "remote-exec" {
        script = "./scripts/init.sh"
    }
}