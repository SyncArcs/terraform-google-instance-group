variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "asia-northeast1"
}

variable "autoscaling_enabled" {
  type        = bool
  default     = true
  description = "Creates an autoscaler for the managed instance group"
}

variable "min_replicas" {
  type        = number
  default     = 1
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler#cpu_utilization"
  type = list(object({
    target            = number
    predictive_method = string
  }))
  default = [
    {
      target            = 0.5
      predictive_method = ""
  }]
}