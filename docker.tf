data "template_file" "cloud-config" {
  template = file("template.cloud-config")

  vars = {
    ssh_key       = var.ssh_key
    # repo_url      = var.repo_url
    # repo_username = var.repo_username
    # repo_password = var.repo_password
  }
}

variable "ssh_key" {
  type = string
}

module "docker" {
  source = "./src"

  name               = "dojo12345"
  vpc_id             = aws_vpc.main.id
  cloud_config_extra          = data.template_file.cloud-config.rendered

  daemon_ssh = "true"
  daemon_tls = "false"

  store_join_tokens_as_tags   = true
  cloudwatch_logs             = false

  managers = 1
  instance_type_manager = "t3.micro"

  workers = 1
  instance_type_worker = "t3.micro"

#   volume_size = "32"

  additional_security_group_ids = [
    aws_security_group.exposed.id,
  ]
}

