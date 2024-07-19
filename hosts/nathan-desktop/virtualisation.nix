{ config, lib, pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.nathan = {
    extraGroups = [ "libvirtd" ];
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virtio-win
  ];
}
