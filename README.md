# Kubernetes cluster on Google Cloud Platform

## Table of Contents
* [About the repo](#about-the-repo)
* [Quick start](#quick-start)
* [Repository structure](#repository-structure)
   * [terraform-modules](#terraform-modules)
   * [k8s-cluster](#k8s-cluster)
   * [accounts](#accounts)
* [CI/CD example with Gitlab CI and Helm](#cicd-example-with-gitlab-ci-and-helm)

## About the repo
This repository contains an example of deploying and managing [Kubernetes](https://kubernetes.io/) clusters to [Google Cloud Platform](https://cloud.google.com/) (GCP) in a reliable and repeatable way.

[Terraform](https://www.terraform.io/) is used to describe the desired state of the infrastructure, thus implementing Infrastructure as Code (IaaC) approach.

[Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) (GKE) service is used for cluster deployment. Since Google announced that [they had eliminated the cluster management fees for GKE](https://cloudplatform.googleblog.com/2017/11/Cutting-Cluster-Management-Fees-on-Google-Kubernetes-Engine.html),
it became the safest and cheapest way to run a Kubernetes cluster on GCP, because you only pay for the nodes (compute instances) running in your cluster and Google abstracts away and takes care of the master control plane.  


## Quick start
**Prerequisite:** make sure you're authenticated to GCP via [gcloud](https://cloud.google.com/sdk/gcloud/) command line tool using either _default application credentials_ or _service account_ with proper access.

Check **terraform.tfvars.example** file inside `k8s-cluster` folder to see what variables you need to define before you can use terraform to create a cluster.

You can run the following command in `k8s-cluster` to make your variables definitions available to terraform:
```bash
$ mv terraform.tfvars.example terraform.tfvars # variables defined in terraform.tfvars will be automatically picked up by terraform during the run
```

Once the required variables are defined, use the commands below to create a Kubernetes cluster:
```bash
$ terraform init
$ terraform apply
```

After the cluster is created, run a command from terraform output to configure access to the cluster via `kubectl` command line tool. The command from terraform output will be in the form of:

```bash
$ gcloud container clusters get-credentials k8s-cluster --zone europe-west1-b --project example-123456
```
After to get access to the cluster via kubectl you can apply your templates, to put your app into pods :
*   :warning: First if you want spanner db you have to put secret key into your kube cluster :
    
    ```bash
    mv scala-api-secret.yml.example scala-api-secret.yml
    ```
    To create your secret key you can do this command (just replace the path to your gcp-key json) :
    
    ```bash
    kubectl create secret generic scala-api-key -n scala-api --from-file=key.json=/path/to/your/gcp/key/json -o=yaml
    ```
    And copy past the output into your scala-api-secret.yml
    
*   You can apply your template :             
    ```bash    
    kubectl -f scala-api.yml -f scala-api-secret.yml apply
    ```

### terraform-modules
The folder contains reusable pieces of terraform code which help us manage our configuration more efficiently by avoiding code repetition and reducing the volume of configuration.

The folder contains 4 modules at the moment of writing:

* `cluster` module allows to create new Kubernetes clusters.
* `firewall/ingress-allow` module allows to create firewall rules to filter incoming traffic.
* `node-pool` module is used to create [Node Pools](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools) which is mechanism to add extra nodes of required configuration to a running Kubernetes cluster. Note that nodes which configuration is specified in the `cluster` module become the _default_ node pool.  
* `vpc` module is used to create new Virtual Private Cloud (VPC) networks.

### k8s-cluster
Inside the **k8s-cluster** folder, I put terraform configuration for the creation and management of an example of Kubernetes cluster.
Important files here:

* `main.tf` is the place where we define main configuration such as creation of a network for our cluster, creation of the cluster itself and node pools.
* `firewall.tf` is used to describe the firewall rules regarding our cluster.
* `dns.tf` is used to manage Google DNS service resources (again with regards to the services and applications which we will run in our cluster).
* `static-ips.tf` is used to manage static IP addresses for services and applications which will be running in the cluster.
* `terraform.tfvars.example` contains example terraform input variables which you need to define before you can start creating a cluster.
* `outputs.tf` contains output variables
* `variables.tf` contains input variables

### accounts
This is another top level folder in this project. It has a separate set of terraform files which are used to manage access accounts to our clusters. For example, you may want to create a service account for your CI tool to allow it to deploy applications to the cluster.

## CI/CD example with Gitlab CI and Helm
For an example of building a CI/CD pipeline with Kubernetes, Gitlab CI, and Helm see [this](http://artemstar.com/2018/01/15/cicd-with-kubernetes-and-gitlab/) blog post.
