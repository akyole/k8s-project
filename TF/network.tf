# specify the provider and access details
provider "aws" {
  region                = "${var.region}"
}

# Get current Availability Zones
data "aws_availability_zones" "available" {}

# Create k8s VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block            = "${var.vpc_cidr}"
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags {
    Name                = "vpc-k8s.${var.environment_tag}"
    Environment         = "${var.environment_tag}"
  }
}

# Create DHCP
resource "aws_vpc_dhcp_options" "k8s_dhcp" {
  domain_name           = "${var.region}.${var.environment_tag}.compute.internal"
  domain_name_servers   = "AmazonProvidedDNS"
  tags {
    Name                = "dhcp-k8s.${var.environment_tag}"
    Environment         = "${var.environment_tag}"
  }
}

# Attach DHCP to VPC
resource "aws_vpc_dhcp_options_association" "kandy_k8s" {
  vpc_id                = "${aws_vpc.k8s_vpc.id}"
  dhcp_options_id       = "${aws_vpc_dhcp_options.k8s_dhcp.id}"
}

# Create Internet GW
resource "aws_internet_gateway" "k8s_igw" {
  vpc_id                = "${aws_vpc.k8s_vpc.id}"
  tags {
    Name                = "igw-k8s.${var.environment_tag}"
    Environment         = "${var.environment_tag}"
  }
}

# Create IGW RT
resource "aws_route_table" "k8s_rt_ext" {
  vpc_id                = "${aws_vpc.k8s_vpc.id}"
  route {
      cidr_block        = "0.0.0.0/0"
      gateway_id        = "${aws_internet_gateway.k8s_igw.id}"
  }
  tags {
    Name                = "rt-ext-k8s.${var.environment_tag}"
    Environment         = "${var.environment_tag}"
  }
}

# Create k8s subnets
resource "aws_subnet" "subnet_k8s" {
  vpc_id                = "${aws_vpc.k8s_vpc.id}"
  cidr_block            = "${var.subnet_k8s}"
  availability_zone     = "eu-central-1a"
  tags {
    Name                = "subnet_k8s.${var.environment_tag}"
    Environment         = "${var.environment_tag}"
  }
}

# Create ACL and associate with subnets
resource "aws_network_acl" "k8s_acl" {
  vpc_id                = "${aws_vpc.k8s_vpc.id}"
  subnet_ids            = "${aws_subnet.subnet_k8s.id}"
  egress {
    protocol            = -1
    rule_no             = 100
    action              = "allow"
    cidr_block          = "0.0.0.0/0"
    from_port           = 0
    to_port             = 0
  }
  ingress {
    protocol            = -1
    rule_no             = 100
    action              = "allow"
    cidr_block          = "0.0.0.0/0"
    from_port           = 0
    to_port             = 0
  }
  tags {
    Name                = "acl-k8s.${var.environment_tag}"
    Environment         = "${var.environment_tag}"
  }
}

# Associate EXT-RT to subnet_k8s
resource "aws_route_table_association" "subnet_k8s_RT" {
  subnet_id             = "${aws_subnet.subnet_k8s.id}"
  route_table_id        = "${aws_route_table.k8s_rt_ext.id}"
}
