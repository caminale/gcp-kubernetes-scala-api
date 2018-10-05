
variable "number_clusters" {
  default = 1
}

variable "gce_zone_list" {
  description = "Run the gce Instances in these Availability Zones"
  type = "list"
  default = ["europe-west1-b","europe-west2-a", "europe-west3-a"]
}

resource "google_container_cluster" "K8s" {
  count              = "${var.number_clusters}"
  name               = "${var.name}-${count.index + 1}"
  description        = "${var.description}"
  zone               = "${element(var.gce_zone_list, count.index)}"
  initial_node_count = "${var.initial_node_count}"

  # node pools will be replicated automatically to the additional zones
//  additional_zones = [
//    "europe-west1-c",
//    "europe-west1-d"
//  ]

//  service_account {
//    email = "roach-468@cockroach-gce.iam.gserviceaccount.com"
//    scopes = ["cloud-platform"]
//  }

  addons_config {
    kubernetes_dashboard {
      disabled = "${var.disable_dashboard}"
    }

    http_load_balancing {
      disabled = "${var.disable_autoscaling_addon}"
    }
  }
 
  network = "${var.network}"

  # node configuration
  # NOTE: nodes created during the cluster creation become the default node pool
  node_config {
    image_type   = "${var.node_image_type}"
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size_gb}"

    # The set of Google API scopes
    # The following scopes are necessary to ensure the correct functioning of the cluster
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    # Tags can used to identify targets in firewall rules
    tags = ["${var.name}-cluster", "nodes"]
  }
}
