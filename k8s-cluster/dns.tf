//resource "google_dns_managed_zone" "primary" {
//  name        = "api-zone"
//  dns_name    = "${var.dns_domain}."
//  description = "DNS zone for the api domain"
//}
//
//resource "google_dns_record_set" "a_record_api" {
//  name = "${google_dns_managed_zone.primary.dns_name}"
//  type = "A"
//  ttl  = 300
//
//  managed_zone = "${google_dns_managed_zone.primary.name}"
//
//  rrdatas = ["${google_compute_global_address.api_static_ip.address}"]
//}
