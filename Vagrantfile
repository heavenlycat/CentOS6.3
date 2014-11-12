# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.box = "CentOS6.3"
	config.vm.box_url = "https://s3.amazonaws.com/itmat-public/centos-6.3-chef-10.14.2.box"

	config.vm.network "private_network", ip: "192.168.33.11"
	config.vm.network "forwarded_port", guest:8080, host: 48080

	config.vm.provider "virtualbox" do |vb|
		vb.name = "CentOS6.3(Tomcat)"
		vb.gui = false
		vb.customize ["modifyvm", :id, "--memory", "1024"]
	end

	config.omnibus.chef_version = :latest
	config.berkshelf.enabled = true

	config.vm.provision :chef_solo do |chef|
		chef.cookbooks_path = ["./site-cookbooks"]
		chef.run_list = [
			"hello",
			"java",
			"tomcat",
			"ark",
			"logrotate",
		]

		chef.json = {
			:java => {
				:jdk_version => 7,
				:install_flavor => 'openjdk'
			},
			:tomcat => {
				:version => '7'
			}

		}
	end
end
