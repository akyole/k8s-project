variable "environment_tag" {
  description = "An environment tag to use in every resource"
  default     = "gerol_project"
}

variable "environment_nick" {
  description = "An environment shortname to use on somewhere"
  default     = "gerol"
}

variable "region" {
  description = "AWS region to work on"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "VPC Network CIDR like 172.22.0.0/16, 10.0.0.0/16"
  default     = "172.21.0.0/16"
}

variable "subnet_k8s" {
  description = "k8s subnet CIDRs"
  default     = [ "172.21.1.0/24" ]
}

variable "home_ip" {
  description = "for SSH login to k8s instances"
  default     = [ "" ]
}

variable "master_node" {
  default = {
      name    = "k8s-master"
      role    = "Master"
      ami     = "ami-090f10efc254eaf55"
      type    = "t2.micro"

  }
}

variable "worker_nodes" {
  default = {
      name    = "k8s-worker"
      role    = "Worker"
      ami     = "ami-090f10efc254eaf55"
      type    = "t2.micro"
      count   = "2"

  }
}

variable "ec2_keypair" {
  description = "The name of keypair that you need while logging via SSH"
  default     = "gerol_project"
}
