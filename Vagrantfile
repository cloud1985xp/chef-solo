# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opscode-ubuntu-14.04"

  config.vm.synced_folder "conf.d", "/svr/conf.d"
  config.vm.provision :shell,
    :inline => "cat /svr/conf.d/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys || exit 0;"

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.define :bbox do |a|
    a.vm.network "private_network", ip: "192.168.33.40"
    a.vm.host_name = 'bbox'
    a.vm.network "forwarded_port", guest: 80, host: 9999
  end

  config.vm.define :rubybox do |a|
    a.vm.network "forwarded_port", guest: 80, host: 8080
    a.vm.network "private_network", ip: "192.168.33.60"
    a.vm.host_name = 'rubybox'
  end

  config.vm.define :bk1 do |a|
    a.vm.network "forwarded_port", guest: 80, host: 8080
    a.vm.network "private_network", ip: "192.168.33.51"
    a.vm.host_name = 'bk1'
  end

  # config.vm.define :zealotv do |a|
  #   a.vm.network "forwarded_port", guest: 80, host: 8082
  #   a.vm.network "private_network", ip: "192.168.33.52"
  #   a.vm.host_name = 'zealotv'
  # end

  # config.vm.define :zealotv do |a|
  #   a.vm.network "forwarded_port", guest: 80, host: 8082
  #   a.vm.network "private_network", ip: "192.168.33.52"
  #   a.vm.host_name = 'zealotv'
  # end

  # config.vm.define :zealotw do |a|
  #   a.vm.network "forwarded_port", guest: 80, host: 8083
  #   a.vm.network "private_network", ip: "192.168.33.54"
  #   a.vm.host_name = 'zealotw'
  # end

  # config.vm.define :vhdtw do |a|
  #   a.vm.network "forwarded_port", guest: 80, host: 8084
  #   a.vm.network "private_network", ip: "192.168.33.84"
  #   a.vm.host_name = 'vhdtw'
  # end

  # config.vm.define :ml do |a|
  #   a.vm.network "forwarded_port", guest: 80, host: 8089
  #   a.vm.network "private_network", ip: "192.168.33.59"
  #   a.vm.host_name = 'ml'
  # end

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
