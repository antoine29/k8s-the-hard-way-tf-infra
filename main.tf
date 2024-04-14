provider "google" {
  project = var.project_id
}

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

# # https://medium.com/@Sakib_Hossain/vpc-peering-with-two-virtual-machines-in-two-different-regions-on-google-cloud-platform-gcp-7dc5f0c4e67d
#

# https://www.geeksforgeeks.org/how-to-use-cloud-nat-for-outbound-internet-access-on-gcp/
#
# https://serverfault.com/questions/947970/google-compute-engine-trouble-accessing-internet-from-an-instance-without-exter
#
# curl -LJO https://github.com/joyent/node/tarball/v0.7.1

