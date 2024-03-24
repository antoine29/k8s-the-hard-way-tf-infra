
## k8s public ip address
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way-public-lb-ip-address \
  --region us-central1 \
  --format 'value(address)')

