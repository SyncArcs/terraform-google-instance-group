output "self_link" {
  description = "Self-link of the managed instance group"
  value       = module.mig.self_link
}

output "id" {
  description = "The GCP id to create and test resources in"
  value       = module.mig.id
}

output "fingerprint" {
  value       = module.mig.fingerprint
  description = "The fingerprint of the instance group manager."
}

output "instance_group_manager" {
  value       = module.mig.instance_group_manager
  description = "An instance of google_compute_region_instance_group_manager of the instance group."
}

output "instance_group" {
  value       = module.mig.instance_group
  description = "Instance-group url of managed instance group"
}

output "health_check_self_links" {
  value       = module.mig.health_check_self_links
  description = "All self_links of healthchecks created for the instance group."
}