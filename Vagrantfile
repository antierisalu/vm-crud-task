# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "base"

    # Load environment variables from .env file
  env_vars = File.readlines('.env').map(&:strip).reject(&:empty?).map do |line|
    if line.include?("=")
      line.split("=", 2)
    else
      nil
    end
  end.compact.to_h

  config.vm.provision "shell", inline: <<-SHELL
    #{env_vars.map { |k, v| "echo 'export #{k}=#{v}' >> /etc/environment" }.join("\n")}
    source /etc/environment
  SHELL

  config.vm.define "gateway" do |g|
    config.vm.box = "ubuntu/focal64"
    g.vm.hostname = "gateway"
    g.vm.network "private_network", ip: "192.168.56.10"  # Example private IP
    g.vm.network "forwarded_port", guest: 3000, host: 3000  # API Gateway port
    g.vm.provision "shell", path: "./scripts/gateway.sh"
    g.vm.provision "shell", run: "always", path: "./scripts/pm2.sh", args: "gateway"
  end

  config.vm.define "inventory" do |i|
    config.vm.box = "ubuntu/focal64"
    i.vm.hostname = "inventory"
    i.vm.network "private_network", ip: "192.168.56.11"  # Example private IP
    i.vm.network "forwarded_port", guest: 8080, host: 8080  # inventory API port
    i.vm.provision "shell", path: "./scripts/inventory.sh"
    i.vm.provision "shell", run: "always", path: "./scripts/pm2.sh", args: "inventory"
  end

  config.vm.define "billing" do |b|
    config.vm.box = "ubuntu/focal64"
    b.vm.hostname = "billing"
    b.vm.network "private_network", ip: "192.168.56.12"  # Example private IP
    b.vm.network "forwarded_port", guest: 5000, host: 5000  # Billing API port
    b.vm.network "forwarded_port", guest: 5672, host: 5672  # RabbitMQ
    b.vm.provision "shell", path: "./scripts/billing.sh"
    b.vm.provision "shell", run: "always", path: "./scripts/pm2.sh", args: "billing"
  end

end
