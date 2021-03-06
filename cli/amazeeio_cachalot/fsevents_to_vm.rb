require 'amazeeio_cachalot/daemon'

class FseventsToVm
  include AmazeeIOCachalot::Daemon
  INSTALL_PATH = AmazeeIOCachalot.brew+"bin"
  BIN_PATH = INSTALL_PATH+"fsevents_to_vm"
  VERSION = "~> 1.1.1"

  attr_reader :machine

  def initialize(machine)
    @machine = machine
  end

  def up
    install_if_necessary!
    increase_inotify_limit
    super
  end

  def plist_name
    "amazeeio_cachalot.fsevents_to_vm.plist"
  end

  def name
    "FsEvents"
  end

  protected

  def install_if_necessary!
    %x{/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/gem list -i -v '#{VERSION}' fsevents_to_vm}
    return if $?.success? and File.exists? BIN_PATH
    puts "Installing fsevents_to_vm, this will require sudo"
    system!("installing", "sudo", "/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/gem", "install", "--no-rdoc", "--no-ri", "-n", INSTALL_PATH, "fsevents_to_vm", "-v", VERSION)
  end

  def increase_inotify_limit
    machine.ssh("echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf > /dev/null")
    machine.ssh("sudo sysctl -p > /dev/null")
  end

  def command
    %W[
      #{BIN_PATH}
      start
      --ssh-identity-file=#{machine.ssh_identity_file_path}
      --ssh-ip=#{machine.vm_ip}
    ]
  end
end
