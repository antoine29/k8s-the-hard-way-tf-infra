# resource "google_compute_network_peering" "vpc-peering-controllers-2-workers" {
#   name = "vpc-peering-controllers-2-workers"
#   network = google_compute_network.vpc-controllers.self_link
#   peer_network = google_compute_network.vpc-workers.self_link
# }
#
# resource "google_compute_network_peering" "vpc-peering-workers-2-controllers" {
#   name = "vpc-peering-workers-2-controllers"
#   network = google_compute_network.vpc-workers.self_link
#   peer_network = google_compute_network.vpc-controllers.self_link
# }

# resource "google_compute_network_peering" "vpc-peering-gateway-2-controllers" {
#   name = "vpc-peering-gateway-2-controllers"
#   network = google_compute_network.vpc-gateway.self_link
#   peer_network = google_compute_network.vpc-controllers.self_link
# }
#
# resource "google_compute_network_peering" "vpc-peering-controllers-2-gateway" {
#   name = "vpc-peering-controllers-2-gateway"
#   network = google_compute_network.vpc-controllers.self_link
#   peer_network = google_compute_network.vpc-gateway.self_link
# }

# gcloud compute networks peerings create spoke-to-hub \
#    --project=$PROJECT_ID \
#    --network=$SPOKE_NETWORK_NAME --peer-network=$HUB_NETWORK_NAME \
#    --auto-create-routes
#
