provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### vpc module call.
#####==============================================================================
module "vpc" {
  source                                    = "git::https://github.com/SyncArcs/terraform-google-vpc.git?ref=v1.0.1"
  name                                      = "app"
  environment                               = "test"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

#####==============================================================================
##### subnet module call.
#####==============================================================================
module "subnet" {
  source        = "git::https://github.com/SyncArcs/terraform-google-subnet.git?ref=v1.0.0"
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
  source      = "git::https://github.com/SyncArcs/terraform-google-firewall.git?ref=v1.0.0"
  name        = "app"
  environment = "test"
  network     = module.vpc.vpc_id

  ingress_rules = [
    {
      name          = "allow-tcp-http-ingress"
      description   = "Allow TCP, HTTP ingress traffic"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22", "80"]
        }
      ]
    }
  ]
}

#####==============================================================================
##### instance_template module call.
#####==============================================================================
module "instance_template" {
  source               = "git::https://github.com/SyncArcs/terraform-google-template-instance.git?ref=v1.0.0"
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
  environment         = "mig-autoscaling"
  region              = var.region
  autoscaling_enabled = var.autoscaling_enabled
  min_replicas        = var.min_replicas
  autoscaling_cpu     = var.autoscaling_cpu
  instance_template   = module.instance_template.self_link_unique
}