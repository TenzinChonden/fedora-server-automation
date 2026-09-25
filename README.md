# Fedora Server Automation (IaC Pipeline)

An automated, modular Infrastructure-as-Code (IaC) deployment pipeline designed to spin up, harden, and configure a production-ready LAMP stack server on Fedora Linux using **KVM/libvirt**, **Cloud-init**, **Ansible**, and a **Makefile** orchestration workflow. 

Designed for frictionless execution, this repository serves as both a local development sandbox and a clean technical portfolio asset.

---

## 🎯 Use Cases 

* **Zero-Risk Experimental Sandbox:** Test new database configurations, system hardening rules, or web frameworks locally without risking host stability. If something breaks, a single command wipes and rebuilds the environment in seconds.
* **Local "Production" Dry-Run:** Validate application deployments, firewall rules, and SELinux policies against a real Linux server environment before deploying to cloud infrastructure.

---

## 🛠️ Tech Stack
* **Virtualization:** KVM / QEMU via `libvirt`
* **Cloud Initialization:** `cloud-init` (ISO-based configuration injection)
* **Configuration Management:** Ansible (Roles, Dynamic Inventory, Plain-text configuration variables)
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
│       └── main.yml            # Global configuration & database variables
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
Clone the repository and run the orchestrator. Because the project uses straightforward plain-text variables, it is 100% plug-and-play with zero decryption setup required:

```bash
git clone https://github.com/YOUR_USERNAME/fedora-server-automation.git
cd fedora-server-automation
make all
```

To clean up and destroy the virtual machine and temporary inventory files:
```bash
make clean
```

---

## 🧪 Practical Example: Testing a Database Configuration Sandbox

One of the primary benefits of this pipeline is the ability to test infrastructure changes safely as code. For example, if you want to test a custom **MariaDB performance tuning configuration** (such as adjusting buffer pools):

1. **Add the configuration task** to your `roles/web/tasks/main.yml`:
   ```yaml
   - name: Deploy custom MariaDB performance tuning configuration
     ansible.builtin.copy:
       dest: /etc/my.cnf.d/tuning.cnf
       content: |
         [mysqld]
         innodb_buffer_pool_size = 256M
         max_connections = 150
       owner: root
       group: root
       mode: "0644"
     notify: Restart mariadb
   ```
2. **Apply the change instantly** (thanks to Ansible idempotency, you don't even need to tear down the VM):
   ```bash
   ansible-playbook site.yml
   ```
3. **Verify the results** by SSHing into your sandbox:
   ```bash
   ssh ansible@<VM_IP>
   sudo mysql -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';"
   ```
4. **Reset if needed:** If an experimental configuration breaks the database, simply run `make clean && make all` to spin up a pristine replacement instance instantly.

---

## 🔮 Next Steps & Potential Upgrades
* **Automated Testing with Molecule & Testinfra:** Add unit and integration tests to validate Ansible roles before deploying them to live instances.
* **CI/CD Pipeline Integration:** Wrap the `Makefile` commands inside a GitHub Actions workflow to automatically lint playbooks (`ansible-lint`) and test provisioning in a CI runner.
* **TLS/Let's Encrypt Automation:** Extend the web role to automatically issue and configure SSL certificates using Certbot for secure HTTPS traffic.
* **Multi-Node Scaling:** Expand the inventory and playbooks to orchestrate a multi-tier architecture separating database nodes from web/application nodes behind a load balancer.
