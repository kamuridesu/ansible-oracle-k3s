vagrant up --provision
ansible-playbook -i inventory/hosts --become-user=root --become --private-key ~/.ssh/id_rsa -u vagrant -vv playbook.yml
sh ./host.sh