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

  config.vm.define "gateway" do |gate|
    config.vm.box = "ubuntu/focal64"
    gate.vm.hostname = "gateway"
    gate.vm.network "private_network", ip: "192.168.56.10"  # Example private IP
    gate.vm.network "forwarded_port", guest: 3000, host: 3000  # API Gateway port
    gate.vm.provision "shell", path: "./scripts/gateway.sh"
    gate.vm.provision "shell", inline: <<-SHELL
      cd $GATEWAY_DIR
      npm start &
      echo "Gateway npm started.."
    SHELL
  end

  config.vm.define "inventory" do |inv|
    config.vm.box = "ubuntu/focal64"
    inv.vm.hostname = "inventory"
    inv.vm.network "private_network", ip: "192.168.56.11"  # Example private IP
    inv.vm.network "forwarded_port", guest: 4000, host: 4000  # inventory API port
    inv.vm.provision "shell", path: "./scripts/inventory.sh"
    inv.vm.provision "shell", inline: <<-SHELL
      cd $INVENTORY_DIR
      npm start &
      echo "Inventory npm started.."
    SHELL

  end

  config.vm.define "billing" do |bill|
    config.vm.box = "ubuntu/focal64"
    bill.vm.hostname = "billing"
    bill.vm.network "private_network", ip: "192.168.56.12"  # Example private IP
    bill.vm.network "forwarded_port", guest: 5000, host: 5000  # Billing API port
    bill.vm.network "forwarded_port", guest: 5672, host: 5672  # RabbitMQ
    bill.vm.provision "shell", path: "./scripts/billing.sh"
    bill.vm.provision "shell", inline: <<-SHELL
      cd $INVENTORY_DIR
      npm start &
      npm start-consumer &
      echo "Billing server and rabbitmq consumer started.."
    SHELL
  end

end
