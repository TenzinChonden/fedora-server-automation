# Fedora Server Automation

An automated, Infrastructure-as-Code (IaC) deployment pipeline for provisioning a secured Fedora Linux virtual server using **KVM/libvirt**, **Cloud-init**, and **Ansible**.

## Features
* **Automated Provisioning:** Spin up disposable Fedora virtual machines instantly with cloud-init configuration.
* **Dynamic Inventory:** Automatically detects and writes the active DHCP IP address into the Ansible inventory.
* **System Hardening:** Enforces SSH hardening, `firewalld` filtering, and strict SELinux policies.
* **Idempotent Deployment:** Re-runnable playbooks ensuring safe, consistent state management.
