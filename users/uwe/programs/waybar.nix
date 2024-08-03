{ mainFontName, lib, config, ... }:
with lib;
{
  programs.waybar = {
    enable = true;

    settings = {
      topBar = {
        layer = "top";
        position = "top";

        modules-left = [
          "battery"
          "network"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "custom/clock"
        ];

        battery = {
          interval = 10;
          states = {
            good = 80;
            warning = 50;
            critical = 9;
          };
          format = "{icon} {capacity}%";
          format-charging = "󱐥 {capacity}%";
          format-plugged = "󱐥 {capacity}%";
          format-full = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          interval = 10;
          format = "{ifname}";
          format-wifi = " {signalStrength}%";
          format-ethernet = "󰲝 {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid}";
          on-click = "alacritty -e nmtui";
        };

        "custom/clock" = {
           exec = "date +'%Y-%m-%dT%H:%M:%S%z'";
           interval = 1;
           tooltip = false ;
        };
      };
    };

    style = ''
         * {
           font-family: "${mainFontName}";
           font-size: 10pt;
           font-weight: normal;
           border-radius: 0px;
           transition-property: background-color;
           transition-duration: 0.5s;
         }
         @keyframes blink_red {
           to {
             background-color: rgb(242, 143, 173);
             color: rgb(0, 0, 0);
           }
         }
         .warning, .critical, .urgent {
           animation-name: blink_red;
           animation-duration: 1s;
           animation-timing-function: linear;
           animation-iteration-count: infinite;
           animation-direction: alternate;
         }
         window#waybar {
           background-color: transparent;
         }
         #workspaces {
           padding-left: 0px;
           padding-right: 4px;
         }
         #workspaces button {
           border-radius: 50%;
           padding: 0px;
         }
         #workspaces button.active {
           background-color: rgba(255, 255, 255, 0.15);
           color: rgba(255, 255, 255, 1);
         }
         #workspaces button:hover {
           color: rgba(0, 0, 0, 1);
         }
         #workspaces button.urgent {
           color: rgb(26, 24, 38);
         }
         tooltip {
           background: #222;
         }
         #custom-clock {
           padding-right: 6px;
           padding-left: .5em;
           margin-left: 2px;
         }
         #network, #battery {
           padding-right: .5em;
           padding-left: .5em;
           margin-right: 2px;
           margin-left: 2px;
         }
         #workspaces button, #network, #custom-clock, #battery {
           color: rgba(255, 255, 255, 0.7);
         }
      '';
  };

  wayland.windowManager.hyprland.extraConfig = mkIf config.wayland.windowManager.hyprland.enable ''
    exec-once = waybar
    exec-once = sleep 2; pkill -SIGKILL '.*waybar.*'
    bind = SUPER, B, exec, pkill -SIGKILL '.*waybar.*' || waybar
  '';
}
