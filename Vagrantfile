# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "brotalk"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
  config.vm.customize ["modifyvm", :id, "--memory", 100]


  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui
  config.vm.define :host1 do |host1|
    #host.vm.forward_port 80, 8080
    host1.vm.network :hostonly, "192.168.33.10"
  end

  config.vm.define :host2 do |host2|
    #host2.vm.forward_port 3306, 3306
    host2.vm.network :hostonly, "192.168.33.11"
  end



  config.vm.provision :shell, :path => "provision.sh"

end
