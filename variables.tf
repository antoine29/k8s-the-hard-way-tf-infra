variable "project_id" {
  type = string
  description = "Project ID"
  default = "gke-test-412223"
}

variable "region" {
  type = string
  description = "Region for this infrastructure"
  default = "us-central1"
}

variable "name" {
  type = string
  description = "Name for this infrastructure"
  default = "kubernetes-the-hard-way"
}

variable "subnet_ip_cidr_range" {
  # type=list(string)
  # description="List of The range of internal addresses that are owned by this subnetwork."
  # default=["10.240.0.0/24"]
  type=string
  description="The range of internal addresses that are owned by this subnetwork."
  default="10.240.0.0/24"
}

