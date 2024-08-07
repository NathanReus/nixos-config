{ pkgs, ... }:

{
  home.packages = with pkgs; [
    noto-fonts
    playerctl
  ];

  services.playerctld.enable = true;

  programs.waybar = {
    enable = true;
    # Unsure if this is needed or not
    package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; });
    settings = {
      mainBar = {
        start_hidden = false;
        margin = "0";
        layer = "top";
        modules-left = [
          "custom/nix"
          "hyprland/workspaces"
          "mpris"
        ];
        modules-center = [
          "wlr/taskbar"
        ];
        modules-right = [
          "custom/task-context"
          "network#interface"
          "network#speed"
          "cpu"
          "temperature"
          "clock"
          "custom/notification"
          "tray"
        ];

        # This was an underscore, not sure if it needs to be
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-number = true;
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3"; 
          };
        };

        mpris = {
          format = "{status_icon}<span weight='bold'>{artist}</span> | {title}";
          status-icons = {
            playing = "󰎈 ";
            paused = "󰏤 ";
            stopped = "󰓛 ";
          };
        };

        "custom/nix" = {
          format = "󱄅 ";
        };

        "wlr/taskbar" = {
          on-click = "activate";
        };

        "custom/task-context" = {
          exec = "~/.config/waybar/scripts/task-context.sh";
          tooltip = false;
          on-click = "task @ none";
          restart-interval = 1;
        };

        "network#interface" = {
          format-ethernet = "󰣶 {ifname}";
          format-wifi = "󰖩 {ifname}";
          tooltip = true;
          tooltip-format = "{ipaddr}";
        };

        "network#speed" = {
          format = "⇡{bandwidthUpBits} ⇣{bandwidthDownBits}";
        };

        cpu = {
          format = " {usage}% 󱐌{avg_frequency}";
        };

        temperature = {
          format = "{icon} {temperatureC} °C";
          format-icons = [ "" "" "" "󰈸" ];
        };

        clock = {
          format = " {:%H:%M}";
          format-alt = "󰃭 {:%Y-%m-%d}";
        };

        "custom/notification" = {
          exec = "~/.config/waybar/scripts/dunst.sh";
          tooltip = false;
          on-click = "dunstctl set-paused toggle";
          restart-interval = 1;
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        min-height: 0;
      }

      window#waybar {
        font-family: 'Noto', 'RobotoMono Nerd Font';
        font-size: 10px;
      }

      tooltip {
        background: @unfocused_borders;
      }

      #custom-nix {
        padding: 0px 4px;
      }

      #workspaces button {
        padding: 0px 4px;
        margin: 0 4px 0 0;
      }

      .modules-right * {
        padding: 0 4px;
        margin: 0 0 0 4px;
      }

      #mpris {
        padding: 0 4px;
      }

      #custom-notification {
        padding: 0 4px 0 4px;
      }

      #tray {
        padding: 0 4px;
      }
      
      #tray * {
        padding: 0;
        margin: 0;
      }
    '';
  };

  xdg.configFile."waybar/scripts/dunst.sh" = {
    text = ''
      COUNT=$(dunstctl count waiting)
      ENABLED="󰂚 "
      DISABLED="󰂛 "
      if [ $COUNT != 0 ]; then DISABLED="󱅫 "; fi
      if dunstctl is-paused | grep -q "false"; then
        echo $ENABLED
      else
        echo $DISABLED
      fi
    '';
    executable = true;
  };

  # TODO: Unsure if this is needed yet, not using tasks
  xdg.configFile."waybar/scripts/task-context.sh" = {
    text = ''
      ICON=" "
      CONTEXT=$(task _get rc.context)

      if [ -z "$CONTEXT" ]; then
        CONTEXT="NONE"
      fi
      echo "$ICON $CONTEXT"
    '';
    executable = true;
  };
}
