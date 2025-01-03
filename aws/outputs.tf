
output "instance_ip_pair" {
  description = "Private/Public IP Pair of the AWS instance"
  value = {
    (aws_instance.example.id) = {
      tag_name   = aws_instance.example.tags.Name
      private_ip = aws_instance.example.private_ip
      public_ip  = aws_instance.example.public_ip
    }
  }
}