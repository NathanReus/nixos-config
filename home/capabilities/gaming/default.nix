{ lib, pkgs, config, inputs, ... }:

{
  imports = [
    ../dunst.nix
    ../waybar.nix 
  ];

  home.packages = with pkgs; [
    # Required for hyprland hardware-acceleration with Nvidia
    nvidia-vaapi-driver
    
    neofetch

    # CLI tool to send commands to MPRIS clients for multimedia control
    playerctl

    # Tool to manage Proton installations
    protonup-qt
  ];

}
