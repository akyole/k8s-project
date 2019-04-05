# SG DB Instances
resource "aws_security_group" "SG-k8s-Instances" {
  name              = "SG.k8s_EC2.${var.environment_tag}"
  description       = "k8s instances"
  vpc_id            = "${aws_vpc.k8s_vpc.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "ssh"
    cidr_blocks     = "${element(var.home_ip,count.index%length(var.home_ip))}"
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name            = "SG.k8s_EC2.${var.environment_tag}"
    Environment     = "${var.environment_tag}"
  }
}
