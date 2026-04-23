
variable "gcp_svc_key" {
  type        = string
  description = "The path to the service account key file."
}

variable "gcp_region" {
  type        = string
  description = "The region in which the resources will be created."
}

variable "gcp_zone" {
  type        = string
  description = "The zone in which the resources will be created."
}

variable "gcp_project_id" {
  type        = string
  description = "The project ID."
}

variable "vm_machine_type" {
  type = string
}

variable "vm_hostname" {
  type = string
  default = ""
}

variable "disk_volume_size" {
  type = number
}

variable "disk_type" {
  type = string
}

variable "resource_prefix" {
  type        = string
  description = "A prefix to apply to all resources in the module."
}

variable "network_subnet_cidr" {
  type        = string
  description = "The CIDR for the network subnet"
}

variable "init_file_directory" {
  type        = string
  default     = ""
  description = "value of the directory containing the initialization scripts"
}
