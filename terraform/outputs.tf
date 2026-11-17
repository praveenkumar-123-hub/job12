
output "vpc_id" {
  description = "Created VPC ID"
  value       = aws_vpc.cynbit_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web_server.public_ip
}

output "website_url" {
  description = "Nginx website URL"
  value       = "http://${aws_instance.web_server.public_ip}"
}
