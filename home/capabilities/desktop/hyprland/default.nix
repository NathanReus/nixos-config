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
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      env = [
        # Nvidia-specific settings
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
        # To attempt to make Electron apps use Wayland natively
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      cursor = {
        # Required for Nvidia
        no_hardware_cursors = true;
      };
      
      exec-once = [
        # Configuration
        "hyprctl setcursor Bibata-Modern-Ice 22"
        "waybar"
        
        # Applications
        "[workspace 1 silent] discord"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 8;
        border_size = 3;
        "col.active_border" = "rgb(F48FB1) rgb (78A8FF) 45deg";
        "col.inactive_border" = "rgba(585272AA)";
        layout = "dwindle";
        resize_on_border = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
        };
        "col.shadow" = "rgba(585272AA)";
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot,0.05,0.9,0.1,1.1"
          "overshot,0.13,0.99,0.29,1"
        ];
        animation = [
          "windows, 1, 7, overshot, slide"
          "border, 1, 10, default"
          "fade, 1, 10, default"
          "workspaces, 1, 7, overshot, slidevert"
        ];
      };

      group = {
        "col.border_active" = "rgba(63F2F1AA)";
        "col.border_inactive" = "rgba(585272AA)";

        groupbar = {
          font_family = "Iosevka";
          font_size = 13;
          "col.active" = "rgba(63F2F1AA)";
          "col.inactive" = "rgba(585272AA)";
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        numlock_by_default = true;
      };

      workspace = lib.lists.flatten (map
        (m:
          map (w: "${w}, monitor:${m.name}") (m.workspaces)
        )
        (config.monitors));

      monitor = map
        (m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in
            "${m.name},${if m.enabled then "${resolution},${position},${toString m.scale}" else "disable"}"
        )
        (config.monitors);

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, class:firefox, title:^Extension: \(Bitwarden Password Manager\) - Bitwarden — Mozilla Firefox$"
        "float, class:steam, title:Friends List"
        "workspace 1, class:discord"
      ];

      "$mainMod" = "SUPER";
      "$browser" = "firefox";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";
      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, W, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod SHIFT, T, togglefloating,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, R, exec, $menu"

        # Move focus with mod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Scroll through existing workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Pause/unpause notifications
        "$mainMod ALT CTRL, equal, exec, dunstctl set-paused toggle"
      ] ++ (
        # Workspaces
        # Binds mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
    };
  };
}
