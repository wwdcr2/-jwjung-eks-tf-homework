resource "aws_eip" "nat_eip" {
  vpc      = true

  tags = {
      Name = "${var.project}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  subnet_id = var.subnet_id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "${var.project}-nat"
  }
}