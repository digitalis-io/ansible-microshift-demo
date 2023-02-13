Vagrant.configure("2") do |config|
  config.vm.box = "fedora/35-cloud-base"
  config.vm.provider "virtualbox" do |v|
    # provides 3GB of memory
    v.memory = 3072
    # for parallelization
    v.cpus = 2
  end

  config.vm.network :forwarded_port, guest: 30036, host: 30036, id: "console"
  config.vm.network :forwarded_port, guest: 80, host: 80, id: "web"

  config.vm.hostname = 'microshift.digitalis.host'
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "sample.yml"
  end
end
