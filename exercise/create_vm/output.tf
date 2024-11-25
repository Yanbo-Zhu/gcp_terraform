
output "my_subnetwork" {
  value = google_compute_subnetwork.subnet
}

output "my_vpc_network" {
  value = google_compute_network.vpc_network
}

output "my_instance" {
  value = google_compute_instance.my_instance.name
  //sensitive = true
}

output "init_file_list" {
  value = fileset(var.init_file_directory, "*")
}

output "init_file_content" {
  value = join("\n", [for tpl in data.template_file.startup_script : tpl.rendered])
}

# Output the SSH keys to confirm retrieval
//output "project_ssh_keys" {
//  value = "${var.ssh_key_username}:${trimspace(data.local_file.ssh_keys.content)}"
//  description = "SSH keys set in the project metadata"
//}

