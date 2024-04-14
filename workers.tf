# # vpc
# resource "google_compute_network" "vpc-workers" {
#   name = "${var.name}-vpc-workers"
#   auto_create_subnetworks = false
#   delete_default_routes_on_create = true
# }
#
# # subnet
# resource "google_compute_subnetwork" "vpc-subnet-workers" {
#   name = "${var.name}-vpc-subnetwork-workers"
#   region = var.region-workers
#   ip_cidr_range = var.workers_cidr_range
#   network = google_compute_network.vpc-workers.id
# }
#
# # firewalls
# resource "google_compute_firewall" "vpc-internal-firewall-workers" {
#   name = "${var.name}-vpc-internal-firewall-workers"
#   network = google_compute_network.vpc-workers.id
#   allow {
#     protocol = "tcp"
#   }
#
#   allow {
#     protocol = "udp"
#   }
#
#   allow {
#     protocol = "icmp"
#   }
#
#   source_ranges = [var.workers_cidr_range] 
# }
#
# resource "google_compute_firewall" "vpc-external-firewall-workers" {
#   name = "${var.name}-vpc-external-firewall-workers"
#   network = google_compute_network.vpc-workers.id
#   allow {
#     protocol = "tcp"
#     ports = ["22", "6443"]
#   }
#   
#   allow {
#     protocol = "icmp"
#   }
#   
#   source_ranges = ["0.0.0.0/0"]
# }
#
# # compute engines
# resource "google_compute_instance" "workers" {
#   count = 3
#   name = "worker-${count.index}"
#   
#   boot_disk {
#     initialize_params {
#       size = "200"
#       image = "ubuntu-2004-focal-v20240307b"
#     }
#   }
#   
#   machine_type = "e2-standard-2"
#   network_interface {
#     subnetwork = google_compute_subnetwork.vpc-subnet-workers.name
#     network_ip = "10.250.0.1${count.index}"
#   }
#   
#   metadata = {
#     pod-cidr = "10.250.${count.index}.0/24"
#   }
#
#   can_ip_forward = true
#   tags = ["kubernetes-the-hard-way", "worker"]
#   service_account {
#     scopes = [
#       "compute-rw", 
#       "storage-ro", 
#       "service-management", 
#       "service-control", 
#       "logging-write", 
#       "monitoring"
#     ]
#   }
#
#   zone = "${var.region-workers}-b"
# }
#
