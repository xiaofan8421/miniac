
output "instance_ip_pair" {
  description = "Private/Public IP Pair of the GCP instance"
  value = {
    (google_compute_instance.example.id) = {
      name       = google_compute_instance.example.name
      private_ip = google_compute_instance.example.network_interface[0].network_ip
      public_ip  = google_compute_instance.example.network_interface[0].access_config[0].nat_ip
    }
  }
}