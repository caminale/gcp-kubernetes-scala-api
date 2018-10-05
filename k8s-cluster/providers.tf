provider "google" {
  version = "~> 1.4.0"
  project = "${var.project_name}"
  credentials = "${file(var.account_file_path)}"
  region  = "${var.region}"
}
