output "subnet_ids" {
  value = aws_subnet.subnet.*.id
}

output "rt_id" {
  value = aws_route_table.rt.id
}