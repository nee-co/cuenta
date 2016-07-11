# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.box = "bento/centos-7.2"

  config.vm.define "cuenta" do |machine|
    machine.vm.network "private_network", ip: (ENV['CUENTA_VM_IP'] || "11.11.11.12"), virtualbox__intnet: "intnet"

    machine.vm.provision :ansible_local, playbook: "./provisioning/setup.yml"

    machine.vm.provider :virtualbox do |vbox|
      vbox.memory = [ENV['CUENTA_VM_MEMORY'].to_i, 1024].max
      vbox.cpus = [ENV['CUENTA_VM_CPUS'].to_i, 1].max
      vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vbox.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end
  end
end
