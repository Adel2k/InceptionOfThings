Vagrant.configure("2") do |config|
  BOX_IMAGE = "ubuntu/jammy64"
  SSH_KEY_PATH = "~/.ssh/id_ed25519.pub"

  config.vm.define "aeminian" do |server|
    server.vm.box = BOX_IMAGE
    server.vm.hostname = "aeminian"
    server.vm.network "private_network", ip: "192.168.56.110"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end

    server.vm.provision "shell", inline: <<-SHELL
      mkdir -p /home/vagrant/.ssh
      echo
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL
  end

  config.vm.define "nkarapet" do |worker|
    worker.vm.box = BOX_IMAGE
    worker.vm.hostname = "nkarapet"
    worker.vm.network "private_network", ip: "192.168.56.111"

    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end

    worker.vm.provision "shell", inline: <<-SHELL
      mkdir -p /home/vagrant/.ssh
      echo
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL
  end
end
