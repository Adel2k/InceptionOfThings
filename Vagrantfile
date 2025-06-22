Vagrant.configure("2") do |config|
  BOX_IMAGE = "ubuntu/jammy64"
  K3S_VERSION = "v1.32.5+k3s1"
  SERVER_IP = "192.168.56.110"
  AGENT_IP = "192.168.56.111"

  config.vm.define "aeminian" do |server|
    server.vm.box = BOX_IMAGE
    server.vm.hostname = "aeminian"
    server.vm.network "private_network", ip: SERVER_IP

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    server.vm.provision "shell", inline: <<-SHELL
      sudo ufw disable
      sudo ufw allow 6443/tcp
      sudo ufw allow from 10.42.0.0/16 to any
      sudo ufw allow from 10.43.0.0/16 to any
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip #{SERVER_IP} --advertise-address #{SERVER_IP}" sh -
      mkdir -p /vagrant/k3s_token
      sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/k3s_token/token
      sudo chown vagrant:vagrant /vagrant/k3s_token/token
    SHELL
  end


  config.vm.define "nkarapet" do |worker|
    worker.vm.box = BOX_IMAGE
    worker.vm.hostname = "nkarapet"
    worker.vm.network "private_network", ip: AGENT_IP

    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    worker.vm.synced_folder "./k3s_token", "/vagrant/k3s_token"

    worker.vm.provision "shell", inline: <<-SHELL
      while [ ! -f /vagrant/k3s_token/token ]; do
        echo "Waiting for token from server..."
        sleep 2
      done

      SERVER_TOKEN=$(cat /vagrant/k3s_token/token)
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --node-ip #{AGENT_IP}" K3S_URL=https://#{SERVER_IP}:6443 K3S_TOKEN=$SERVER_TOKEN sh -
    SHELL
    end
  end
