resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project}-rt-${var.isPublic}"
  }
}

resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr)
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  vpc_id = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-sub-${var.isPublic}-${substr(var.azs[count.index],-1,-1)}"
    }
  )
}

resource "aws_route_table_association" "rt_asso" {
  count = length(var.subnet_cidr)
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.subnet[count.index].id
}