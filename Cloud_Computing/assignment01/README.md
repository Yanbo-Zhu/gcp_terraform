
# 1 Virtual Machines

## 1.1 Enable nested virtualization


Confirm that nested virtualization is enabled on the VM
https://cloud.google.com/compute/docs/instances/nested-virtualization/enabling#confirm_that_nested_virtualization_is_enabled_on_the_vm

Any response other than 0 confirms that nested virtualization is enabled.

`grep -cw vmx /proc/cpuinfo`






# 2 Prepare Virtualization Technologies

[Create nested VMs](https://cloud.google.com/compute/docs/instances/nested-virtualization/creating-nested-vms)

[How to Enable Nested Virtualization on GCP Using Terraform?](https://blog.communityof.cloud/how-to-enable-nested-virtualization-on-gcp-using-terraform-0bebfa0424a8)

## 2.1 install qemu-kvm 

Install the latest qemu-kvm package: `sudo apt update && sudo apt install qemu-kvm -y`

After the “kvm-ok” command you need to get a response like below.
```
alpernbt@master:~$ kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
```

## 2.2 

2. Download a QEMU-compatible OS image to use for the L2 VM.




