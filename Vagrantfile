Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|
 
     vb.memory = "1024"
     vb.cpus = "1"
   end
# creating node 
    config.vm.define "node1" do |machine|
      machine.vm.hostname = "node1"
      machine.vm.network "private_network", ip: "192.168.56.41"
      machine.vm.provision "shell", inline: <<-SHELL
        hostnamectl set-hostname node1
        sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
        service ssh restart
      SHELL
    end

# creating controller
    config.vm.define 'controller' do |machine|
      machine.vm.hostname = "controller"
      machine.vm.network "private_network", ip: "192.168.56.40"
      machine.vm.synced_folder "\playbook", "/Vagrant"
      machine.vm.provision :ansible_local do |ansible|
        ansible.config_file    = "ansible.cfg"
        ansible.playbook       = "controller.yaml"
        ansible.verbose        = true
        ansible.install        = true
        ansible.limit          = "all" # or only "nodes" group, etc.
        ansible.inventory_path = "inventory"
      end

      machine.vm.provision "shell", inline: <<-SHELL
        sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
        service ssh restart
      SHELL
      
       

      $script = "/usr/bin/expect /vagrant/vagkey.sh $1"
      machine.vm.provision :shell do |shell|
        shell.privileged  = false
        shell.inline      = $script
        shell.args        = "#{ENV['vpass']}"
      end
      
      machine.vm.provision :ansible_local do |ansible|
        ansible.config_file    = "ansible.cfg"
        ansible.playbook       = "node.yaml"
        ansible.verbose        = true
        ansible.install        = true
        ansible.limit          = "all" # or only "nodes" group, etc.
        ansible.inventory_path = "inventory"
      end

      $script1 = "/usr/bin/expect /vagrant/anskey.sh $1"
      machine.vm.provision :shell do |shell|
        shell.privileged  = "ansadmin"
        shell.inline      = $script1
        shell.args        = "#{ENV['apass']}"
      end

      machine.vm.provision :ansible_local do |ansible|
        ansible.config_file    = "ansible.cfg"
        ansible.playbook       = "ansnode.yaml"
        ansible.verbose        = true
        ansible.install        = true
        ansible.limit          = "all" # or only "nodes" group, etc.
        ansible.inventory_path = "inventory"
      end

      machine.vm.provision :ansible_local do |ansible|
        ansible.config_file    = "ansible.cfg"
        ansible.playbook       = "apache.yaml"
        ansible.verbose        = true
        ansible.install        = true
        ansible.limit          = "all" # or only "nodes" group, etc.
        ansible.inventory_path = "inventory"
      end

    end
end
