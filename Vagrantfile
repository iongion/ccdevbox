Vagrant.configure('2') do |config|
  config.vm.network 'public_network'
  config.vm.box = 'ubuntu/xenial64'
  config.vm.provider 'virtualbox' do |vb|
    vb.name = "ethdev"
    vb.memory = '1024'
  end
  config.vm.provision 'shell', inline: "bash /vagrant/scripts/install.sh"
end
