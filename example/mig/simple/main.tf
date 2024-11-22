provider "google" {
  project = "local-concord-408802"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### vpc module call.
#####==============================================================================
module "vpc" {
  source                                    = "SyncArcs/vpc/google"
  version                                   = "1.0.1"
  name                                      = "app"
  environment                               = "test"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

#####==============================================================================
##### subnet module call.
#####==============================================================================
module "subnet" {
  source        = "SyncArcs/subnet/google"
  version       = "1.0.1"
  name          = "app"
  environment   = "test"
  subnet_names  = ["subnet-a"]
  gcp_region    = "asia-northeast1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.1.0/24"]
}

#####==============================================================================
##### firewall module call.
#####==============================================================================
module "firewall" {
  source        = "SyncArcs/firewall/google"
  version       = "1.0.1"
  name          = "app"
  environment   = "test"
  network       = module.vpc.vpc_id
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

#####==============================================================================
##### instance_template module call.
#####==============================================================================
module "instance_template" {
  source               = "SyncArcs/template-instance/google"
  version              = "1.0.1"
  name                 = "template"
  environment          = "test"
  region               = "asia-northeast1"
  source_image         = "ubuntu-2204-jammy-v20230908"
  source_image_family  = "ubuntu-2204-lts"
  source_image_project = "ubuntu-os-cloud"
  disk_size_gb         = "20"
  subnetwork           = module.subnet.subnet_id
  instance_template    = true
  service_account      = null
  ## public IP if enable_public_ip is true
  enable_public_ip = true
  metadata = {
    ssh-keys = <<EOF
      dev:ssh-rsa AAAAB3NzaC1yc2EAA/3mwt2y+PDQMU= ashish@ashish
    EOF
  }
}

#####==============================================================================
##### instance_group module call.
#####==============================================================================
module "mig" {
  source              = "../../../"
  hostname            = "test"
  environment         = "mig-simple"
  region              = "asia-northeast1"
  target_size         = 1
  autoscaling_enabled = false
  instance_template   = module.instance_template.self_link_unique

  autoscaling_cpu = [
    {
      target            = 0.7
      predictive_method = null
    },
  ]
}