provider "google" {
  region = var.region
}

resource "google_compute_network" "example" {
  name                    = "tf-test-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "example" {
  name          = "tf-test-subnet"
  network       = google_compute_network.example.id
  ip_cidr_range = "172.16.1.0/24"
}

resource "google_compute_address" "example" {
  region = var.region
  name   = "tf-test-compute-address"
}

resource "google_compute_firewall" "inbound" {
  name    = "tf-test-compute-firewall-inbound"
  network = google_compute_network.example.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "outbound" {
  name    = "tf-test-compute-firewall-outbound"
  network = google_compute_network.example.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-all-outbound"]
}

resource "google_compute_instance" "example" {
  zone         = var.zone
  name         = "tf-test-vm"
  machine_type = "e2-micro" # 1C1G

  boot_disk {
    initialize_params {
      image = var.image
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.example.self_link
    subnetwork = google_compute_subnetwork.example.self_link

    access_config {
      nat_ip = google_compute_address.example.address
    }
  }

  metadata = {
    ssh-keys = "tf:${file("${var.ssh_key_path}.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "tf"
    private_key = file("${var.ssh_key_path}")
    host        = self.network_interface[0].access_config[0].nat_ip
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
      "curl -H 'Metadata-Flavor: Google' 'http://metadata.google.internal/computeMetadata/v1/instance/?recursive=true'",
      "sudo bash /tmp/deploy_env.sh",
      "echo remote-exec end...",
    ]
  }
}
