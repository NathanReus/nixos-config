{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/monitors.nix
    ../capabilities/desktop
    ../capabilities/git
    ../capabilities/firefox
    ../capabilities/shell.nix
    ../capabilities/gaming
  ];
  
  home = {
    username = "nathan";
    homeDirectory = "/home/nathan";
    # Determines HM release that config is compatible with.
    # Helps avoid breakage when new release has backwards
    # incompatible changes.
    # Can update HM without changing this. See HM release notes
    # for list of state version changes.
    stateVersion = "24.05";
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
    packages = with pkgs; [
      neofetch

      # archives
      zip
      xz
      unzip
      p7zip

      # misc
      which
      tree

      # apps
      discord
    ];
  };

  # Allow fontconfig to discover fonts and configs installed through `home.packages`.
  fonts.fontconfig.enable = true;

  programs = {
    # Let HM install and manage itself.
    home-manager.enable = true;
  };

  monitors = [
    {
      name = "HDMI-A-2";
      width = 2560;
      height = 1440;
      workspaces = [ "1" ];
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 144;
      x = 2560;
      workspaces = [ "2" ];
    }
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      x = 5120;
      workspaces = [ "3" ];
    }
    # Disable a ghost screen due to driver bug https://github.com/hyprwm/Hyprland/issues/5958
    {
      name = "Unknown-1";
      enabled = false;
    }
  ];
}
