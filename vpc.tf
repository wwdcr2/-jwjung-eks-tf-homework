# VPC CIDR
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# VPC & Internet Gateway
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# Public & Private Subnets
locals {
  region = "ap-northeast-2"
  azs    = ["${local.region}a", "${local.region}c"]

  subnet_cidrs = {
    pub = [cidrsubnet(var.vpc_cidr, 8, 0), cidrsubnet(var.vpc_cidr, 8, 1)],
    pri = [cidrsubnet(var.vpc_cidr, 8, 2), cidrsubnet(var.vpc_cidr, 8, 3)]
  }
}

module "subnets" {
  source = "./module/subnet"
  for_each = local.subnet_cidrs

  project     = var.project
  vpc_id      = aws_vpc.vpc.id
  isPublic    = each.key
  subnet_cidr = each.value
  azs         = local.azs
  tags = each.key == "pub" ? { "kubernetes.io/role/elb" = 1 } : { "kubernetes.io/cluster/${local.cluster_name}" = "shared"}
}

# NAT Gateway in Public-A Subnet
module "nat" {
  source = "./module/nat"

  project   = var.project
  subnet_id = module.subnets["pub"].subnet_ids.0
}

# Routing to Internet Gateway or NAT Gateway
resource "aws_route" "pub_igw_route" {
  route_table_id         = module.subnets["pub"].rt_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "pri_nat_route" {
  route_table_id         = module.subnets["pri"].rt_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.nat.nat_id
}