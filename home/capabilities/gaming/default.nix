{ lib, pkgs, config, inputs, ... }:

{
  imports = [
  ];

  home.packages = with pkgs; [
    # Tool to manage Proton installations
    protonup-qt

    lutris
    heroic
  ];

}
