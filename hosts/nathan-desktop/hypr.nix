{ pkgs, ... }:

{
  programs.hyprland.enable = true;
  # Below may be needed to use SDDM for login, other options exist
  #services.xserver = {
    #enable = true;
    #displayManager.sddm = {
      #enable = true;
      #wayland.enable = true;
    #};
  #};

  # May be needed for Hyprland to run nicely
  #xdg.portal = {
    #extraPortals = [
      #pkgs.xdg-desktop-portal-gtk
    #];
  #};
}
