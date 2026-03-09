{ pkgs, lib, ... }: {

  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;

    docker = {
      enable = true;
      # start `sudo systemctl start docker`
      enableOnBoot = false;
      rootless = {
        enable = false; # needed for winboat
        setSocketVariable = true;
      };
      autoPrune = {
        enable = true;
        dates = "monthly";
        persistent = true;
        flags = [ "--all" ];
      };
    };

    # following configuration is added only when building VM with build-vm
    # https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
    vmVariant.virtualisation = {
      memorySize = 4096; # Use 4GB memory.
      diskSize = 28192; # MB → 28 GB
      cores = 2;
    };
  };

  programs.virt-manager.enable = true;

  # for OSX-KVM
  # https://wiki.nixos.org/wiki/OSX-KVM
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
}
