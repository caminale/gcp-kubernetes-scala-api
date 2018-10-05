# create network to run cluster instances
module "k8s_network" {
  source = "../terraform-modules/vpc"
  name   = "${var.ntw_name}"
}

# create cluster
module "k8s_cluster" {
  source             = "../terraform-modules/cluster"
  name               = "${var.name}"
  description        = "${var.description}"
  zone               = "${var.zone}"
  initial_node_count = "${var.initial_node_count}"
  network            = "${module.k8s_network.name}"
}
