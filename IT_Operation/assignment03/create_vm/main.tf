module "create_vm" {
  source = "../../../modules/create-vm"

  gcp_svc_key         = var.gcp_svc_key
  gcp_region          = var.gcp_region
  gcp_zone            = var.gcp_zone
  gcp_project_id      = var.gcp_project_id
  vm_machine_type     = var.vm_machine_type
  vm_disk_volume_size = var.vm_disk_volume_size
  vm_hostname         = "prometheus-server"
  resource_prefix     = var.resource_prefix
  network_subnet_cidr = var.network_subnet_cidr
  init_file_directory = "./init_file_prometheus_server"

}
