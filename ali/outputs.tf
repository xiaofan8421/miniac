
output "instance_ip_pair" {
  description = "Private/Public IP Pair of the ALI instance"
  value = {
    (alicloud_instance.example.id) = {
      instance_name = alicloud_instance.example.instance_name
      private_ip    = alicloud_instance.example.private_ip
      public_ip     = alicloud_instance.example.public_ip
    }
  }
}