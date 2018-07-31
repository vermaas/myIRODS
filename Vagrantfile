# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # config.hostmanager.enabled = true
  config.ssh.forward_x11 = true
  config.vm.box ="ubuntu/trusty64"
  config.disksize.size = "100GB"

  # this is a trick to chmod the private key in the /vagrant directory to 775, otherwise Ansible won't accept the too open key.
  config.vm.synced_folder "./", "/vagrant", owner: "vagrant", :mount_options => ["dmode=775,fmode=600"]

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.memory = 512
    ### Change network card to PCnet-FAST III
    # For NAT adapter
    vb.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
    # For host-only adapter
    vb.customize ["modifyvm", :id, "--nictype2", "Am79C973"]
  end

  config.vm.define "irods-vm" do |node|
    node.vm.network "private_network", ip: "192.168.13.13"
  end

  config.vm.define "controller-irods-vm" do |node|
    node.vm.network "private_network", ip: "192.168.13.10"
    node.vm.provision :ansible_local do |ansible|
        ansible.install = true
        ansible.install_mode = "pip"
        ansible.version = "2.3.2"
        ansible.inventory_path = "vagrant_ansible_inventory"
        ansible.playbook = "playbook.yml"
        ansible.verbose = "vv"
        ansible.limit = "all"

        ansible.raw_arguments = ["--extra-vars @/vagrant/files/ansible-vars.yml"]
   end
  end

end