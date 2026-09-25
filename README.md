# Fedora Server Automation (IaC Pipeline)

An automated, modular Infrastructure-as-Code (IaC) deployment pipeline designed to spin up, harden, and configure a production-ready LAMP stack server on Fedora Linux using **KVM/libvirt**, **Cloud-init**, **Ansible**, and a **Makefile** orchestration workflow.

---

## 🎯 Use Cases
* **Reproducible Development Labs:** Instantly spin up disposable, fully configured virtual servers for testing applications or system configuration scripts without risking host stability.
* **Staging Server Provisioning:** Provides a blueprint for rapidly bootstrapping secure web application nodes with pre-configured firewall rules, SELinux policies, and database instances.

---

## 🛠️ Tech Stack
* **Virtualization:** KVM / QEMU via `libvirt`
* **Cloud Initialization:** `cloud-init` (ISO-based configuration injection)
* **Configuration Management:** Ansible (Roles, Vault, Dynamic Inventory)
* **Orchestration:** GNU Make (`Makefile`)
* **Security & Hardening:** SELinux (Enforcing), `firewalld`, SSH key-based access with root login disabled, POSIX ACLs.
* **Services:** Apache (`httpd`), MariaDB, PHP 8.x

---

## 📂 Project Structure
```text
.
├── ansible.cfg                 # Global Ansible configurations
├── Makefile                    # End-to-end automation orchestrator
├── site.yml                    # Main entry-point playbook
├── requirements.yml            # Ansible Galaxy collection dependencies
├── scripts/
│   ├── create-vm.sh            # Provisions KVM guest via cloud-init ISO
│   └── gen-inventory.sh        # Dynamically queries libvirt DHCP for guest IP
├── group_vars/
│   └── all/
│       ├── main.yml            # Global configuration variables
│       └── vault.yml           # Encrypted credentials (passwords)
└── roles/
    ├── base/                   # System users, SSH hardening, firewalld, SELinux
    └── web/                    # LAMP stack installation, DB setup, health-check app
```

---

## 🚀 Quick Start / How to Use

### Prerequisites
Ensure your local host machine has the required virtualization and automation packages installed:
* Fedora Linux host with KVM/libvirt enabled (`sudo dnf install @virtualization`)
* Ansible (`sudo dnf install ansible`)
* GNU Make and standard utilities

### Execution
With a single command, the Makefile will tear down any existing test instance, create a fresh Fedora VM, generate the dynamic inventory, run the full Ansible configuration hardening pipeline, and deploy the application:

```bash
make all
```

To clean up and destroy the virtual machine and temporary inventory files:
```bash
make clean
```

---

## 🔮 Recommended Next Steps & Potential Upgrades
To take this infrastructure project to the next enterprise-grade level, consider implementing the following enhancements:
1. **Automated Testing with Molecule & Testinfra:** Add unit and integration tests to validate Ansible roles before deploying them to live instances.
2. **CI/CD Pipeline Integration:** Wrap the `Makefile` commands inside a GitHub Actions workflow to automatically lint playbooks (`ansible-lint`) and test provisioning in a CI runner.
3. **TLS/Let's Encrypt Automation:** Extend the web role to automatically issue and configure SSL certificates using Certbot for secure HTTPS traffic.
4. **Multi-Node Scaling:** Expand the inventory and playbooks to orchestrate a multi-tier architecture separating database nodes from web/application nodes behind a load balancer (HAProxy or Nginx).
