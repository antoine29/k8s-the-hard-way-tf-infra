# # vpc
# resource "google_compute_network" "vpc-controllers" {
#   name = "${var.name}-vpc-controllers"
#   auto_create_subnetworks = false
#   delete_default_routes_on_create = true
# }
#
# # subnet
# resource "google_compute_subnetwork" "vpc-subnet-controllers" {
#   name = "${var.name}-vpc-subnetwork-controllers"
#   region = var.region-controllers
#   ip_cidr_range = var.controllers_cidr_range
#   network = google_compute_network.vpc-controllers.id
# }
#
# # firewalls
# # resource "google_compute_firewall" "vpc-internal-firewall-controllers" {
# #   name = "${var.name}-vpc-internal-firewall-controllers"
# #   network = google_compute_network.vpc-controllers.id
# #   allow {
# #     protocol = "tcp"
# #   }
# #
# #   allow {
# #     protocol = "udp"
# #   }
# #
# #   allow {
# #     protocol = "icmp"
# #   }
# #
# #   source_ranges = [var.controllers_cidr_range] 
# # }
#
# resource "google_compute_firewall" "vpc-external-firewall-controllers" {
#   name = "${var.name}-vpc-external-firewall-controllers"
#   network = google_compute_network.vpc-controllers.id
#   allow {
#     protocol = "tcp"
#     ports = ["22", "6443"]
#   }
#   
#   allow {
#     protocol = "icmp"
#   }
#   
#   source_ranges = [
#     "0.0.0.0/0",
#   ]
# }
#
# # compute engines
# resource "google_compute_instance" "controllers" {
#   # count = 3
#   count = 1
#   name  = "controller-${count.index}"
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
#     subnetwork = google_compute_subnetwork.vpc-subnet-controllers.name
#     network_ip = "10.240.0.1${count.index}"
#   }
#
#   can_ip_forward = true
#   # tags  = ["allow-ssh"] // this receives the firewall rule
#   tags = ["kubernetes-the-hard-way", "controller"]
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
#   zone = "${var.region-controllers}-a"
# }
#
# # cloud router
# resource "google_compute_router" "router" {
#   project = var.project_id
#   name    = "nat-router"
#   network = google_compute_network.vpc-controllers.id
#   region  = var.region-controllers
# }
#
# module "cloud-nat" {
#   source  = "terraform-google-modules/cloud-nat/google"
#   version = "~> 5.0"
#
#   project_id                          = var.project_id
#   region                              = var.region-controllers
#   router                              = google_compute_router.router.name
#   name                                = "nat-config"
#   source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }
#
