data "template_file" "cloud-config" {
  template = file("template.cloud-config")

  vars = {
    ssh_key       = var.ssh_key
  }
}

variable "ssh_key" {
  type = string
}

variable "name" {
  type = string
}

variable "instances" {
  type = integer
  default = 1
}

variable "worker_instance_type" {
  type = string
  default = "t3.micro"
}

variable "manager_instances" {
  type = integer
  default = 1
}

variable "manager_instance_type" {
  type = string
  default = "t3.micro"
}

variable "volume_size" {
  type = integer
  default = 8
}

module "docker" {
  source = "./src"

  name               = var.name
  vpc_id             = aws_vpc.main.id
  cloud_config_extra          = data.template_file.cloud-config.rendered

  daemon_ssh = "true"
  daemon_tls = "false"

  store_join_tokens_as_tags   = true
  cloudwatch_logs             = false

  managers = var.manager_instances
  instance_type_manager = var.manager_instance_type 

  workers = var.instances
  instance_type_worker = var.worker_instance_type #"t3.micro"

  volume_size = var.volume_size

  additional_security_group_ids = [
    aws_security_group.exposed.id,
  ]
}

