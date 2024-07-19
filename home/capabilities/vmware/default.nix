{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    vmware-workstation
  ];

}
