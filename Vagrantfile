# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "install/bootstrap.sh"

  MonitorCount = 3

  (1..MonitorCount).each do |i|

    config.vm.define "monitor0#{i}" do |node|

      node.vm.box               = "generic/ubuntu2004"
      node.vm.box_check_update  = false
      node.vm.box_version       = "4.2.6"
      node.vm.hostname          = "monitor0#{i}.example.com"

      node.vm.network "private_network", ip: "172.16.2.10#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "monitor0#{i}"
        v.memory  = 2048
        v.cpus    = 2
      end

      node.vm.provider :libvirt do |v|
        v.nested  = true
        v.memory  = 2048
        v.cpus    = 2
      end

    end

  end

end
