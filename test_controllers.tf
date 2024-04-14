# # vpc
# resource "google_compute_network" "vpc-controllers" {
#   name = "${var.name}-vpc-controllers"
#   auto_create_subnetworks = false
# }
#
# # subnet
# resource "google_compute_subnetwork" "vpc-subnet-test" {
#   name = "${var.name}-vpc-subnetwork-test"
#   region = var.region-test
#   ip_cidr_range = var.workers_cidr_range
#   network = google_compute_network.vpc-test.id
# }
#
# resource "google_compute_firewall" "vpc-ssh-firewall-rule" {
#  name = "${var.name}-vpc-ssh-firewall-rule"
#  network = google_compute_network.vpc-test.id
#  allow {
#    protocol = "tcp"
#    ports = ["22"]
#  }
#  
#  source_ranges = ["0.0.0.0/0"]
# }
#
# # compute engines
# resource "google_compute_instance" "testers" {
#   count = 1
#   name = "tester-${count.index}"
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
#     subnetwork = google_compute_subnetwork.vpc-subnet-test.name
#     network_ip = "10.250.0.1${count.index}"
#   }
#   
#   metadata = {
#     pod-cidr = "10.250.${count.index}.0/24"
#   }
#
#   can_ip_forward = true
#   tags = ["kubernetes-the-hard-way", "tester"]
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
#   zone = "${var.region-test}-b"
# }
#
# resource "google_compute_router" "router" {
#   project = var.project_id
#   name    = "nat-router"
#   network = google_compute_network.vpc-test.id
#   region  = var.region-test
# }
#
# module "cloud-nat" {
#   source  = "terraform-google-modules/cloud-nat/google"
#   version = "~> 5.0"
#
#   project_id                          = var.project_id
#   region                              = var.region-test
#   router                              = google_compute_router.router.name
#   name                                = "nat-config"
#   source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }
#
