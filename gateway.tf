# vpc
#resource "google_compute_network" "vpc-gateway" {
#  name = "${var.name}-vpc-gateway"
#  auto_create_subnetworks = false
#  delete_default_routes_on_create = true
#}

# subnet
#resource "google_compute_subnetwork" "vpc-subnet-gateway" {
#  name = "${var.name}-vpc-subnetwork-gateway"
#  region = var.region-controllers
#  ip_cidr_range = var.controllers_cidr_range
#  network = "192.168.0.0/23"
#}

