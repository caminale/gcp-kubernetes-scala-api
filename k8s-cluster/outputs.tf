output "api_ip" {
  value = "${google_compute_global_address.api_static_ip.address}"
}

output "kubconfig" {
  value = " ... \nRun command to configure access via kubectl:\n$ gcloud container clusters get-credentials ${var.name} --zone ${var.zone} --project ${var.project_id}"
}
