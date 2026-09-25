#!/usr/bin/env bash
set -euo pipefail
export LIBVIRT_DEFAULT_URI=qemu:///system
VM_NAME="${VM_NAME:-fedora-lab}"

for _ in $(seq 1 30); do
  IP=$(virsh domifaddr "$VM_NAME" --source lease 2>/dev/null \
       | awk '/ipv4/ {print $4}' | cut -d/ -f1 | head -n1)
  [ -n "$IP" ] && break
  sleep 3
done
[ -n "${IP:-}" ] || { echo "No IP found for $VM_NAME" >&2; exit 1; }

mkdir -p inventory
cat > inventory/hosts.ini <<HOSTS_EOF
[lab]
${VM_NAME} ansible_host=${IP} ansible_user=ansible
HOSTS_EOF
echo "Inventory written: ${VM_NAME} -> ${IP}"
