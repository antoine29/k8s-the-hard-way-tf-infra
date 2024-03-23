provider "google" {
  project = var.project_id
}

# ---------------------------------------------------------------------
# controllers 

# vpc
resource "google_compute_network" "vpc-controllers" {
  name = "${var.name}-vpc-controllers"
  auto_create_subnetworks = false
  
}

# subnet
resource "google_compute_subnetwork" "vpc-subnet-controllers" {
  name = "${var.name}-vpc-subnetwork-controllers"
  region = var.region-controllers
  ip_cidr_range = var.controllers_cidr_range
  network = google_compute_network.vpc-controllers.id
}

# firewalls
resource "google_compute_firewall" "vpc-internal-firewall-controllers" {
  name = "${var.name}-vpc-internal-firewall-controllers"
  network = google_compute_network.vpc-controllers.id
  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.controllers_cidr_range] 
}

resource "google_compute_firewall" "vpc-external-firewall-controllers" {
  name = "${var.name}-vpc-external-firewall-controllers"
  network = google_compute_network.vpc-controllers.id
  allow {
    protocol = "tcp"
    ports = ["22", "6443"]
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = ["0.0.0.0/0"]
}

# compute engines
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
    subnetwork = google_compute_subnetwork.vpc-subnet-controllers.name
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

  zone = "${var.region-controllers}-a"
}

# -------------------------------------------------------------------
# workers

# vpc
resource "google_compute_network" "vpc-workers" {
  name = "${var.name}-vpc-workers"
  auto_create_subnetworks = false
}

# subnet
resource "google_compute_subnetwork" "vpc-subnet-workers" {
  name = "${var.name}-vpc-subnetwork-workers"
  region = var.region-workers
  ip_cidr_range = var.workers_cidr_range
  network = google_compute_network.vpc-workers.id
}

# firewalls
resource "google_compute_firewall" "vpc-internal-firewall-workers" {
  name = "${var.name}-vpc-internal-firewall-workers"
  network = google_compute_network.vpc-workers.id
  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.workers_cidr_range] 
}

resource "google_compute_firewall" "vpc-external-firewall-workers" {
  name = "${var.name}-vpc-external-firewall-workers"
  network = google_compute_network.vpc-workers.id
  allow {
    protocol = "tcp"
    ports = ["22", "6443"]
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = ["0.0.0.0/0"]
}

# compute engines
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
    subnetwork = google_compute_subnetwork.vpc-subnet-workers.name
    network_ip = "10.250.0.1${count.index}"
  }
  
  metadata = {
    pod-cidr = "10.250.${count.index}.0/24"
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

  zone = "${var.region-workers}-b"
}

resource "google_compute_network_peering" "vpc-controllers-peering" {
  name = "vpc-controllers-peering"
  network = google_compute_network.vpc-controllers.self_link
  peer_network = google_compute_network.vpc-workers.self_link
}

resource "google_compute_network_peering" "vpc-workers-peering" {
  name = "vpc-workers-peering"
  network = google_compute_network.vpc-workers.self_link
  peer_network = google_compute_network.vpc-controllers.self_link
}

# --------------------------------------------------------

# # LB public ip address
# resource "google_compute_address" "public-lb-ip-address" {
#   name = "${var.name}-public-lb-ip-address"
#   region = var.region-controllers
# }
#
# # Outputs
# output "public-lb-ip-address" {
#   value = google_compute_address.public-lb-ip-address.address
# }
#
# # https://medium.com/@Sakib_Hossain/vpc-peering-with-two-virtual-machines-in-two-different-regions-on-google-cloud-platform-gcp-7dc5f0c4e67d
#
