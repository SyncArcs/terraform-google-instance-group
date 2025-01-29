# Terraform-google-instance-group
# Terraform Google Cloud Instance-Group Module
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create Instance-Group.
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
### Examples

## Example: complete

```hcl
module "mig" {
  source                       = "git::https://github.com/SyncArcs/terraform-google-instance-group.git?ref=v1.0.0"
  hostname                     = "test"
  environment                  = "instance-group"
  region                       = var.region
  min_replicas                 = var.min_replicas
  max_replicas                 = var.max_replicas
  target_pools                 = var.target_pools
  distribution_policy_zones    = var.distribution_policy_zones
  update_policy                = var.update_policy
  named_ports                  = var.named_ports
  health_check                 = var.health_check
  autoscaling_enabled          = var.autoscaling_enabled
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control
  instance_template            = module.instance_template.self_link_unique
}
```

## Example: autoscaling

```hcl
module "mig" {
  source              = "git::https://github.com/SyncArcs/terraform-google-instance-group.git?ref=v1.0.0"
  hostname            = "test"
  environment         = "mig-autoscaling"
  region              = var.region
  autoscaling_enabled = var.autoscaling_enabled
  min_replicas        = var.min_replicas
  autoscaling_cpu     = var.autoscaling_cpu
  instance_template   = module.instance_template.self_link_unique
}
```
## Example: health-check

```hcl
module "mig" {
  source              = "git::https://github.com/SyncArcs/terraform-google-instance-group.git?ref=v1.0.0"
  hostname            = "test"
  environment         = "instance-group"
  region              = "asia-northeast1"
  autoscaling_enabled = true
  min_replicas        = 1
  instance_template   = module.instance_template.self_link_unique

  autoscaling_cpu = [
    {
      target            = 0.4
      predictive_method = null
    },
  ]

  health_check = {
    type                = "https"
    initial_delay_sec   = 120
    check_interval_sec  = 5
    healthy_threshold   = 2
    timeout_sec         = 5
    unhealthy_threshold = 2
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = "localhost"
    enable_logging      = false
  }
}
```
## Example: simple

```hcl
module "mig" {
  source              = "git::https://github.com/SyncArcs/terraform-google-instance-group.git?ref=v1.0.0"
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
```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/SyncArcs/terraform-google-instance-group/tree/master/example/mig) directory within this repository.

## Author
Your Name Replace **MIT** and **SyncArcs** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/SyncArcs/terraform-google-instance-group/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.50, < 5.11.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.48, < 5.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.50, < 5.11.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.48, < 5.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/SyncArcs/terraform-google-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_region_instance_group_manager.mig](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_instance_group_manager) | resource |
| [google_compute_health_check.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.tcp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_region_autoscaler.autoscaler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_cpu"></a> [autoscaling\_cpu](#input\_autoscaling\_cpu) | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization | <pre>list(object({<br>    target            = number<br>    predictive_method = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Creates an autoscaler for the managed instance group | `string` | `"false"` | no |
| <a name="input_autoscaling_lb"></a> [autoscaling\_lb](#input\_autoscaling\_lb) | Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_metric"></a> [autoscaling\_metric](#input\_autoscaling\_metric) | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric | <pre>list(object({<br>    name   = string<br>    target = number<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_mode"></a> [autoscaling\_mode](#input\_autoscaling\_mode) | Operating mode of the autoscaling policy. If omitted, the default value is ON. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler#mode | `string` | `null` | no |
| <a name="input_autoscaling_scale_in_control"></a> [autoscaling\_scale\_in\_control](#input\_autoscaling\_scale\_in\_control) | Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control | <pre>object({<br>    fixed_replicas   = number<br>    percent_replicas = number<br>    time_window_sec  = number<br>  })</pre> | <pre>{<br>  "fixed_replicas": null,<br>  "percent_replicas": null,<br>  "time_window_sec": null<br>}</pre> | no |
| <a name="input_cooldown_period"></a> [cooldown\_period](#input\_cooldown\_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. | `number` | `60` | no |
| <a name="input_distribution_policy_target_shape"></a> [distribution\_policy\_target\_shape](#input\_distribution\_policy\_target\_shape) | MIG target distribution shape (EVEN, BALANCED, ANY, ANY\_SINGLE\_ZONE) | `string` | `null` | no |
| <a name="input_distribution_policy_zones"></a> [distribution\_policy\_zones](#input\_distribution\_policy\_zones) | The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region. | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check to determine whether instances are responsive and able to do work | <pre>object({<br>    type                = string<br>    initial_delay_sec   = number<br>    check_interval_sec  = number<br>    healthy_threshold   = number<br>    timeout_sec         = number<br>    unhealthy_threshold = number<br>    response            = string<br>    proxy_header        = string<br>    port                = number<br>    request             = string<br>    request_path        = string<br>    host                = string<br>    enable_logging      = bool<br>  })</pre> | <pre>{<br>  "check_interval_sec": 30,<br>  "enable_logging": false,<br>  "healthy_threshold": 1,<br>  "host": "",<br>  "initial_delay_sec": 30,<br>  "port": 80,<br>  "proxy_header": "NONE",<br>  "request": "",<br>  "request_path": "/",<br>  "response": "",<br>  "timeout_sec": 10,<br>  "type": "",<br>  "unhealthy_threshold": 5<br>}</pre> | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname prefix for instances | `string` | `"default"` | no |
| <a name="input_instance_template"></a> [instance\_template](#input\_instance\_template) | Instance template self\_link used to create compute instances | `string` | n/a | yes |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'SyncArcs'. | `string` | `"SyncArcs"` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas. | `number` | `10` | no |
| <a name="input_mig_timeouts"></a> [mig\_timeouts](#input\_mig\_timeouts) | Times for creation, deleting and updating the MIG resources. Can be helpful when using wait\_for\_instances to allow a longer VM startup time. | <pre>object({<br>    create = string<br>    update = string<br>    delete = string<br>  })</pre> | <pre>{<br>  "create": "5m",<br>  "delete": "15m",<br>  "update": "5m"<br>}</pre> | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `2` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `"test"` | no |
| <a name="input_named_ports"></a> [named\_ports](#input\_named\_ports) | Named name and named port. https://cloud.google.com/load-balancing/docs/backend-service#named_ports | <pre>list(object({<br>    name = string<br>    port = number<br>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where the managed instance group resides. | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/SyncArcs/terraform-google-instance-group"` | no |
| <a name="input_scaling_schedules"></a> [scaling\_schedules](#input\_scaling\_schedules) | Autoscaling, scaling schedule block. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler#scaling_schedules | <pre>list(object({<br>    disabled              = bool<br>    duration_sec          = number<br>    min_required_replicas = number<br>    name                  = string<br>    schedule              = string<br>    time_zone             = string<br>  }))</pre> | `[]` | no |
| <a name="input_stateful_disks"></a> [stateful\_disks](#input\_stateful\_disks) | Disks created on the instances that will be preserved on instance delete. https://cloud.google.com/compute/docs/instance-groups/configuring-stateful-disks-in-migs | <pre>list(object({<br>    device_name = string<br>    delete_rule = string<br>  }))</pre> | `[]` | no |
| <a name="input_stateful_ips"></a> [stateful\_ips](#input\_stateful\_ips) | Statful IPs created on the instances that will be preserved on instance delete. https://cloud.google.com/compute/docs/instance-groups/configuring-stateful-ip-addresses-in-migs | <pre>list(object({<br>    interface_name = string<br>    delete_rule    = string<br>    is_external    = bool<br>  }))</pre> | `[]` | no |
| <a name="input_target_pools"></a> [target\_pools](#input\_target\_pools) | The target load balancing pools to assign this group to. | `list(string)` | `[]` | no |
| <a name="input_target_size"></a> [target\_size](#input\_target\_size) | The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set. | `number` | `1` | no |
| <a name="input_update_policy"></a> [update\_policy](#input\_update\_policy) | The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy | <pre>list(object({<br>    max_surge_fixed              = number<br>    instance_redistribution_type = string<br>    max_surge_percent            = number<br>    max_unavailable_fixed        = number<br>    max_unavailable_percent      = number<br>    min_ready_sec                = number<br>    replacement_method           = string<br>    minimal_action               = string<br>    type                         = string<br>  }))</pre> | `[]` | no |
| <a name="input_wait_for_instances"></a> [wait\_for\_instances](#input\_wait\_for\_instances) | Whether to wait for all instances to be created/updated before returning. Note that if this is set to true and the operation does not succeed, Terraform will continue trying until it times out. | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fingerprint"></a> [fingerprint](#output\_fingerprint) | The fingerprint of the instance group manager. |
| <a name="output_health_check_self_links"></a> [health\_check\_self\_links](#output\_health\_check\_self\_links) | All self\_links of healthchecks created for the instance group. |
| <a name="output_id"></a> [id](#output\_id) | an identifier for the resource with format |
| <a name="output_instance_group"></a> [instance\_group](#output\_instance\_group) | Instance-group url of managed instance group |
| <a name="output_instance_group_manager"></a> [instance\_group\_manager](#output\_instance\_group\_manager) | An instance of google\_compute\_region\_instance\_group\_manager of the instance group. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | Self-link of managed instance group |
<!-- END_TF_DOCS -->