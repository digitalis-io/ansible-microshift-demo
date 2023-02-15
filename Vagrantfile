Vagrant.configure("2") do |config|
  config.vm.box = "fedora/35-cloud-base"
  config.vm.provider "virtualbox" do |v|
    # provides 3GB of memory
    v.memory = 3072
    # for parallelization
    v.cpus = 2
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.network "public_network", type: "dhcp"
  config.vm.network "private_network", :type => 'dhcp', :adapter => 2

  config.vm.network :forwarded_port, guest: 30090, host: 30090, id: "console"
  config.vm.network :forwarded_port, guest: 30080, host: 30080, id: "web"
  config.vm.network :forwarded_port, guest: 30443, host: 30443, id: "argocd"

  config.vm.hostname = 'microshift.digitalis.host'

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "vagrant.yml"
  end
end
