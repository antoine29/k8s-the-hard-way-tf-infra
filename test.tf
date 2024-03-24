# vpc
resource "google_compute_network" "vpc-test" {
  name = "${var.name}-vpc-test"
  auto_create_subnetworks = false
}

# subnet
resource "google_compute_subnetwork" "vpc-subnet-test" {
  name = "${var.name}-vpc-subnetwork-test"
  region = var.region-test
  ip_cidr_range = var.workers_cidr_range
  network = google_compute_network.vpc-test.id
}

# firewalls
#resource "google_compute_firewall" "vpc-internal-firewall-workers" {
#  name = "${var.name}-vpc-internal-firewall-workers"
#  network = google_compute_network.vpc-workers.id
#  allow {
#    protocol = "tcp"
#  }
#
#  allow {
#    protocol = "udp"
#  }
#
#  allow {
#    protocol = "icmp"
#  }
#
#  source_ranges = [var.workers_cidr_range] 
#}
#
#resource "google_compute_firewall" "vpc-external-firewall-workers" {
#  name = "${var.name}-vpc-external-firewall-workers"
#  network = google_compute_network.vpc-workers.id
#  allow {
#    protocol = "tcp"
#    ports = ["22", "6443"]
#  }
#  
#  allow {
#    protocol = "icmp"
#  }
#  
#  source_ranges = ["0.0.0.0/0"]
#}

# compute engines
resource "google_compute_instance" "testers" {
  count = 1
  name = "tester-${count.index}"
  
  boot_disk {
    initialize_params {
      size = "200"
      image = "ubuntu-2004-focal-v20240307b"
    }
  }
  
  machine_type = "e2-standard-2"
  network_interface {
    subnetwork = google_compute_subnetwork.vpc-subnet-test.name
    network_ip = "10.250.0.1${count.index}"
  }
  
  metadata = {
    pod-cidr = "10.250.${count.index}.0/24"
  }

  can_ip_forward = true
  tags = ["kubernetes-the-hard-way", "tester"]
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

  zone = "${var.region-test}-b"
}

