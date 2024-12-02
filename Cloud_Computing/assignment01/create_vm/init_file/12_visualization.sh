!/bin/bash

# https://cloud.google.com/compute/docs/instances/nested-virtualization/creating-nested-vms

sudo apt-get update && sudo apt upgrade


###########################
#Creating an L2 VM with external network access
###########################

# install kvm 
sudo apt -y install qemu qemu-kvm 
sudo apt -y install cpu-checker # The kvm-ok command is provided by the cpu-checker package, not a package named kvm-ok


########################################
# Creating an L2 VM with a private network bridge to the L1 VM
########################################
sudo apt -y install bridge-utils libvirt-clients libvirt-daemon libvirt-daemon-system 
sudo apt -y install uml-utilities virtinst 