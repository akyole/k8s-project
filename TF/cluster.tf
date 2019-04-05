# Create k8s cluster

# Create k8s-master node
resource "aws_instance" "k8s-master" {
  ami                     = "${var.master_node["ami"]}"
  instance_type           = "${var.master_node["type"]}"
  disable_api_termination = false
  key_name                = "${var.ec2_keypair}"
  count                   = "1"
  subnet_id               = "${aws_subnet.subnet_k8s.id}"
  vpc_security_group_ids  = "${aws_security_group.SG-k8s-Instances.id}"

  tags {
      Name                = "${var.master_node["name"]}"
      Environment         = "${var.environment_tag}"
      Role                = "${var.master_node["role"]}"
  }
}

# Create k8s-worker nodes
resource "aws_instance" "k8s-nodes" {
  ami                     = "${var.worker_nodes["ami"]}"
  instance_type           = "${var.worker_nodes["type"]}"
  disable_api_termination = false
  key_name                = "${var.ec2_keypair}"
  count                   = "${var.worker_nodes["count"]}"
  subnet_id               = "${aws_subnet.subnet_k8s.id}"
  vpc_security_group_ids  = "${aws_security_group.SG-k8s-Instances.id}"

  tags {
      Name                = "${var.worker_nodes["name"]}-${count.index}"
      Environment         = "${var.environment_tag}"
      Role                = "${var.master_node["role"]}"
  }
}

