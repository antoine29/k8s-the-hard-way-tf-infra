provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_compute_zones" "this" {
  region = var.region
  project = var.project_id
}

locals {
  type = ["public", "private"]
  zones = data.google_compute_zones.this.names
}

# VPC
resource "google_compute_network" "vpc" {
  name = "${var.name}-vpc"
  auto_create_subnetworks = false
}

# SUBNET
resource "google_compute_subnetwork" "vpc-subnet" {
  # count = 1
  # name="${var.name}-${local.type[count.index]}-subnetwork"
  name="${var.name}-subnetwork"
  # ip_cidr_range = var.subnet_ip_cidr_range[count.index]
  ip_cidr_range = var.subnet_ip_cidr_range
  network=google_compute_network.vpc.id
}

# # VPC FIREWALL
# resource "google_compute_firewall" "vpc-allow-internal-firewall" {
#   name = "${var.name}-vpc-allow-internal-firewall"
#   network = google_compute_network.vpc.id
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
#   source_ranges = var.subnet_ip_cidr_range 
# }
#
# resource "google_compute_firewall" "vpc-allow-external-firewall" {
#   name = "${var.name}-vpc-allow-external-firewall"
#   network = google_compute_network.vpc.id
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
# # LB public ip address
# resource "google_compute_address" "public-lb-ip-address" {
#   name = "${var.name}-public-lb-ip-address"
#   region = var.region
# }

# controllers
resource "google_compute_instance" "controllers" {
  count = 3
  name = "controller-${count.index}"
  
  boot_disk {
    initialize_params {
      size = "200"
      image = "ubuntu-2004-focal-v20240307b"
    }
  }
  
  machine_type = "e2-standard-2"
  
  network_interface {
    subnetwork = google_compute_subnetwork.vpc-subnet.name
    network_ip = "10.240.0.1${count.index}"
  }

  can_ip_forward = true
  tags = ["kubernetes-the-hard-way", "controller"]
  service_account {
    scopes = [
      "compute-rw", 
      "storage-ro", 
      "service-management", 
      "service-control", 
      "logging-write", 
      "monitoring"
    ]
  }

  zone = "us-central1-a"
}

# workers
resource "google_compute_instance" "workers" {
  count = 3
  name = "worker-${count.index}"
  
  boot_disk {
    initialize_params {
      size = "200"
      image = "ubuntu-2004-focal-v20240307b"
    }
  }
  
  machine_type = "e2-standard-2"
  
  network_interface {
    subnetwork = google_compute_subnetwork.vpc-subnet.name
    network_ip = "10.240.0.2${count.index}"
  }
  
  metadata = {
    pod-cidr = "10.200.${count.index}.0/24"
  }
  can_ip_forward = true
  tags = ["kubernetes-the-hard-way", "worker"]
  service_account {
    scopes = [
      "compute-rw", 
      "storage-ro", 
      "service-management", 
      "service-control", 
      "logging-write", 
      "monitoring"
    ]
  }

  zone = "us-east1-b"
}

# # Outputs
# output "public-lb-ip-address" {
#   value = google_compute_address.public-lb-ip-address.address
# }


# https://medium.com/@Sakib_Hossain/vpc-peering-with-two-virtual-machines-in-two-different-regions-on-google-cloud-platform-gcp-7dc5f0c4e67d
