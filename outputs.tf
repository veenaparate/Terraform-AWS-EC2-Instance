output "http_server_public_dns" {
  value = aws_instance.myserver.public_dns
}
