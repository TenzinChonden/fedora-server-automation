#!/usr/bin/env bash
set -euo pipefail

VM_NAME="${VM_NAME:-fedora-lab}"
BASE_IMG="${BASE_IMG:-/var/lib/libvirt/images/fedora-cloud-base.qcow2}"
DISK="/var/lib/libvirt/images/${VM_NAME}.qcow2"
PUBKEY="$(cat "${SSH_KEY:-$HOME/.ssh/fedora-lab}.pub")"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
export LIBVIRT_DEFAULT_URI=qemu:///system

cat > "$WORKDIR/user-data" <<CLOUD_EOF
#cloud-config
users:
  - name: ansible
    groups: wheel
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${PUBKEY}
CLOUD_EOF

cat > "$WORKDIR/meta-data" <<CLOUD_EOF
instance-id: ${VM_NAME}
local-hostname: ${VM_NAME}
CLOUD_EOF

sudo qemu-img create -f qcow2 -F qcow2 -b "$BASE_IMG" "$DISK" 20G

virt-install \
  --name "$VM_NAME" --memory 4096 --vcpus 2 \
  --disk path="$DISK",format=qcow2 \
  --os-variant fedora-unknown \
  --network network=default \
  --cloud-init user-data="$WORKDIR/user-data",meta-data="$WORKDIR/meta-data" \
  --import --noautoconsole
