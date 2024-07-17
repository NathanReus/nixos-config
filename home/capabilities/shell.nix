{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "RobotoMono" "Iosevka" ]; })
    ibm-plex
    iosevka

    zip
    xz
    unzip
    p7zip

    which
    tree
  ];

  # This is where to enable things like ZSH, Starship, etc when I get to it
}
