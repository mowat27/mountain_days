# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.50.6"

  config.ssh.forward_agent = true

  config.vm.define "dockerbox" do |docker|
    docker.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/vagrant.yml"
      ansible.host_key_checking = false
      ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
      ansible.sudo = true
    end
  end
end
