provider "alicloud" {
  region = var.region
}

resource "alicloud_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = "172.16.1.0/24"
  zone_id    = var.zone
}

resource "alicloud_security_group" "group" {
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_key_pair" "my_key" {
  public_key = file("${var.ssh_key_path}.pub")
}

resource "alicloud_security_group_rule" "allow_ssh" {
  security_group_id = alicloud_security_group.group.id

  type        = "ingress"
  ip_protocol = "tcp"
  nic_type    = "intranet"
  policy      = "accept"
  port_range  = "22/22"
  priority    = 1
  cidr_ip     = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_outbound" {
  security_group_id = alicloud_security_group.group.id

  type        = "egress"
  ip_protocol = "all"
  nic_type    = "intranet"
  policy      = "accept"
  priority    = 1
  cidr_ip     = "0.0.0.0/0"
}


resource "alicloud_instance" "example" {
  availability_zone = alicloud_vswitch.vswitch.zone_id
  vswitch_id        = alicloud_vswitch.vswitch.id
  image_id          = var.image

  instance_name        = "tf-test-vm"
  instance_type        = "ecs.t6-c2m1.large" # 2C1G
  instance_charge_type = "PostPaid"

  system_disk_category = "cloud_auto"
  system_disk_size     = "20"

  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = "10"
  security_groups            = [alicloud_security_group.group.id]
  key_name                   = alicloud_key_pair.my_key.key_pair_name

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_key_path)
    host        = self.public_ip
    timeout     = "3m"
  }

  provisioner "file" {
    source      = "../deploy_env.sh"
    destination = "/tmp/deploy_env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "echo remote-exec begin...",
      "curl -s http://100.100.100.200/latest/meta-data/instance/instance-type",
      "curl -s http://100.100.100.200/latest/meta-data/eipv4",
      "bash /tmp/deploy_env.sh",
      "echo remote-exec end...",
    ]
  }
}
