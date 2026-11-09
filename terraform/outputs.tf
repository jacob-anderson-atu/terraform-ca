output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "instance_ids" {
  value = [aws_instance.web_01.id, aws_instance.web_02.id]
}

output "ebs_volume_id" {
  value = aws_ebs_volume.data.id
}