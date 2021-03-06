# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_EXPERIMENTAL'] = "typed_triggers,disks"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.synced_folder ".", "/shared"
  config.vm.disk :disk, size: "50GB", primary: true
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.33"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "10240"
    vb.cpus = 6
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y \
      gawk \
      wget \
      git-core \
      diffstat \
      unzip \
      texinfo \
      gcc-multilib \
      build-essential \
      chrpath \
      socat \
      cpio \
      python \
      python3 \
      python3-pip \
      python3-pexpect \
      xz-utils \
      debianutils \
      iputils-ping

    # Workaround for "Error: [Errno 1] Operation not permitted." 
    # that happens when Yocto build directory is shared folder in VirtualBox.
    mkdir -p /project/build
    ln -s /shared/build/conf /project/build/conf
    ln -s /shared/src /project/src
    chown -R vagrant:vagrant /project
    rsync -ah /shared/build/sstate-cache/ /project/build/sstate-cache/

    cat <<'    EOT' >> /home/vagrant/.bashrc
      cd /project/
      . src/poky/oe-init-build-env build
      export DL_DIR="/shared/build/downloads"
      export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE DL_DIR"
    EOT
  SHELL

  config.trigger.before :halt, :destroy do |trigger|
    trigger.warn = "Synchronize sstate cache dir ..."
    trigger.run_remote = {
        inline: <<-SHELL
          rsync -ahc /project/build/sstate-cache/ /shared/build/sstate-cache/
        SHELL
    }
  end
end
