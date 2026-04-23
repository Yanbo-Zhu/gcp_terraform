# creating random ids
resource "random_id" "my_random_id" {
  byte_length = 4
}



####################################################
# Network Configuration
####################################################

resource "google_compute_network" "vpc_network" {
  name                    = "${var.resource_prefix}-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.resource_prefix}-subnet"
  ip_cidr_range            = var.network_subnet_cidr
  network                  = google_compute_network.vpc_network.self_link
  region                   = var.gcp_region
  private_ip_google_access = true
}

resource "google_compute_address" "static_ip_address" {
  name = lower("${var.resource_prefix}-static-ip-address-${random_id.my_random_id.hex}")
}

resource "google_compute_firewall" "my_firewall_rule" {
  // If no targetTags are specified, the firewall rule applies to all instances on the specified network.

  name    = "${var.resource_prefix}-firewall-rule"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"] # Port für HTTP, HTTPS, SSH
  }

  # Allow ICMP traffic (useful for ping)
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["9090"] # Port für Prometheus
  }


  # Optional attributes
  description = "Allow HTTP, HTTPS, SSH ,  ICMP and other traffic"
  direction   = "INGRESS"

  source_tags = ["cc"]
  target_tags = ["cc"]

  source_ranges = ["0.0.0.0/0"] # Allows access from any IP range (use restrictive IPs if needed)

  # Only allow SSH access to instances with this service account
  #target_service_accounts = [google_service_account.my_service_account.email]

}

/*
####################################################
# Project Metadata
####################################################

# Read the SSH keys from the local file
data "local_file" "ssh_keys" {
  filename = var.ssh_key_file_path
}


resource "google_compute_project_metadata" "my_ssh_key" {
  project = var.gcp_project_id

  metadata = {
    ssh-keys = "${var.ssh_key_username}:${trimspace(data.local_file.ssh_keys.content)}"
  }
}
*/


####################################################
# IAM Configuration
####################################################

resource "google_service_account" "my_service_account" {
  account_id   = "${var.resource_prefix}-service-account"
  display_name = "Custom Service account for VM Instance"
}


resource "google_project_iam_binding" "log_user" {
  project = var.gcp_project_id
  role    = "roles/editor"
  members = [
    "serviceAccount:${google_service_account.my_service_account.email}"
  ]
}

####################################################
# VM Instance Configuration
####################################################

data "google_compute_image" "ubuntu_2004" {
  family      = "ubuntu-pro-2004-lts"
  project     = "ubuntu-os-pro-cloud"
  most_recent = true
}

data "template_file" "startup_script" {
  for_each = fileset(var.init_file_directory, "*")
  template = file("${var.init_file_directory}/${each.value}")
}


resource "google_compute_disk" "my_disk" {
  name = "${var.resource_prefix}-disk-${random_id.my_random_id.hex}"
  type = var.disk_type
  zone = var.gcp_zone
  size = var.disk_volume_size # GB
  // only use an image data source if you're ok with the disk recreating itself with a new image periodically
  image = data.google_compute_image.ubuntu_2004.self_link
}


resource "google_compute_instance" "my_instance" {

  name         = "${var.resource_prefix}-${var.vm_machine_type}-${random_id.my_random_id.hex}"
  machine_type = var.vm_machine_type
  zone         = var.gcp_zone

  hostname = var.vm_hostname != "" ? "${var.vm_hostname}.${var.resource_prefix}.${var.vm_machine_type}.${random_id.my_random_id.hex}" : "${var.resource_prefix}.${var.vm_machine_type}.${random_id.my_random_id.hex}"


  min_cpu_platform = "Automatic"

  tags = ["cc"]

  boot_disk {
    /*
    initialize_params {
      image = data.google_compute_image.ubuntu_2004.self_link
      size  = 100 # GB
      labels = {
        my_label = "value"
      }
    }
    */

    source = google_compute_disk.my_disk.self_link
  }

  /*
  # Local SSD disk
  scratch_disk {
    interface = "NVME"
  }


  # Attach additional disk
  attached_disk {
    source      = google_compute_disk.my_disk.self_link # Reference the created disk
    device_name = google_compute_disk.my_disk.name
  }

  */

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Ephemeral static IP
      nat_ip = google_compute_address.static_ip_address.address
    }
  }

  metadata = {
    foo = "bar"
    # ssh-keys = "${var.ssh_key_username}:${trimspace(data.local_file.ssh_keys.content)}"  # This is not needed as it is already set in the project metadata
    block-project-ssh-keys = false
  }

  # metadata_startup_script
  //metadata_startup_script = file("./init_file/10_initialization.sh")
  metadata_startup_script = join("\n", [for tpl in data.template_file.startup_script : tpl.rendered])

  # If true, allows Terraform to stop the instance to update its properties.
  allow_stopping_for_update = true

  advanced_machine_features {
    enable_nested_virtualization = true
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.my_service_account.email
    scopes = ["cloud-platform"]
  }
}
