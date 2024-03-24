variable "project_id" {
  type = string
  description = "Project ID"
  default = "gke-test-412223"
}

variable "region-controllers" {
  type = string
  description = "Region for controllers"
  default = "us-central1"
}

variable "region-workers" {
  type = string
  description = "Region for workers"
  default = "us-east1"
}

variable "region-test" {
  type = string
  description = "Region for testing"
  default = "us-west1"
}

variable "name" {
  type = string
  description = "Name for this infrastructure"
  default = "kubernetes-the-hard-way"
}

variable "controllers_cidr_range" {
  type=string
  description="The range of internal addresses for controllers subnetwork"
  default="10.240.0.0/24"
}

variable "workers_cidr_range" {
  type=string
  description="The range of internal addresses for workers subnetwork"
  default="10.250.0.0/24"
}

