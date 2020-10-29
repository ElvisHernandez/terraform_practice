
resource "aws_security_group" "default" {
    description = "Allow ssh connections on port 22, http on port 80, and https on port 443"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "bastion" {
    ami           = "ami-038e35de01603d84e"
    instance_type = "t3.micro"
    key_name = local.pem_file["key_name"]
    security_groups = [aws_security_group.default.name]
    user_data = file("./scripts/setup.sh")

    root_block_device {
        volume_type = "standard"
        volume_size = 50
    }
}

resource "null_resource" "init_server" {

    depends_on = [aws_instance.bastion]

    triggers = {
        bastion_public_ip = aws_instance.bastion.public_ip
    }

    connection {
		host = aws_instance.bastion.public_ip
		type = "ssh"
		user = "ubuntu"
		agent = "true"
		private_key = file(local.pem_file["key_path"])
    }

    provisioner "remote-exec" {
        inline = [
            "echo \"DOMAIN=${var.domain}\" >> /tmp/.env",
            "echo \"NGINX_USERNAME=${var.nginx_username}\" >> /tmp/.env",
            "echo \"NGINX_PASSWORD=${var.nginx_password}\" >> /tmp/.env",
            "echo \"DIRECTUS_ADMIN_EMAIL=${var.directus_admin_email}\" >> /tmp/.env",
            "echo \"DIRECTUS_ADMIN_PASSWORD=${var.directus_admin_password}\" >> /tmp/.env",
            "echo \"GITLAB_CI_CD_TOKEN=${var.gitlab_ci_cd_token}\" >> /tmp/.env",
            "echo \"DIRECTUS_API_TOKEN=${var.directus_api_token}\" >> /tmp/.env",
            "echo \"AWS_KEY=${aws_iam_access_key.iam_user_credentials.id}\" >> /tmp/.env",
            "echo \"AWS_SECRET=${aws_iam_access_key.iam_user_credentials.secret}\" >> /tmp/.env",
            "echo \"AWS_BUCKET=${aws_s3_bucket.default.id}\" >> /tmp/.env"
        ]
    }

	provisioner "file" {
        # Copy over gitlab ssh credentials to server
		source = "${path.module}/../../private/gitlab/"
		destination = "/home/ubuntu/.ssh/"
	}

    provisioner "file" {
        # Copy over nginx configs to server
        source = "./nginx/conf.d"
        destination = "/tmp"
    }

    provisioner "file" {
        # Copy over shell scripts to server
        source = "./scripts/"
        destination = "/tmp/"
    }
}
