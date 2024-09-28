{ config, pkgs, ... }:

{
  # Enable VirtualBox
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  # Load VirtualBox kernel modules
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" "kvm-intel" ];  # Add kvm-intel (or kvm-amd for AMD processors)

  # Install VirtualBox package
  environment.systemPackages = with pkgs; [
    virtualboxWithExtpack
  ];

  # Add user to vboxusers group
  users.extraGroups.vboxusers.members = [ "jonash" ];

  # Enable KVM
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;

  # Optional: Set up VirtualBox web service
  # Uncomment if you want to use VirtualBox's web interface
  # virtualisation.virtualbox.host.enableWebService = true;
  # services.virtualboxHost.enableWebService = true;

  # Optional: Set up VirtualBox headless service
  # Uncomment if you want to run VMs without a GUI
  # virtualisation.virtualbox.host.enableHardening = false;
  # systemd.services.vboxweb-service.enable = true;
}
