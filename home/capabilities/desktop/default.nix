{ pkgs, ... }:

{
  imports = [
    ./hyprland
  ];

  home.packages = with pkgs; [
    font-manager
  ];

  programs.wofi.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Teal-Dark-Dracula";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = [ "purple" "teal" "grey" "green" ];
        tweaks = [ "dracula" ];
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme.override {
        roundedIcons = true;
        allColorVariants = true;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-gtk";
  };

}
