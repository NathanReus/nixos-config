{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
    qpwgraph
  ];
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
