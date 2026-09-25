.PHONY: all provision inventory deploy clean

all: clean provision inventory deploy

provision:
	./scripts/create-vm.sh

inventory:
	./scripts/gen-inventory.sh

deploy:
	ansible-playbook site.yml

clean:
	@echo "Tearing down existing lab VM..."
	virsh destroy fedora-lab 2>/dev/null || true
	virsh undefine fedora-lab --remove-all-storage 2>/dev/null || true
	@rm -f inventory/hosts.ini
