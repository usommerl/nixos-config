{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      topBar = {
        layer = "top";
        position = "top";

        modules-left = ["hyprland/workspaces"];
        modules-center = [];
        modules-right = [
          "network"
          "battery"
	  "custom/clock"
        ];

        battery = {
          states = {
            good = 90;
            warning = 50;
            critical = 25;
          };
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          format = "{ifname}";
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}/{cidr}";
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
           font-family: "JetBrainsMono Nerd Font";
           font-size: 10pt;
           font-weight: normal;
           border-radius: 0px;
           transition-property: background-color;
           transition-duration: 0.5s;
         }
         @keyframes blink_red {
           to {
             background-color: rgb(242, 143, 173);
             color: rgb(26, 24, 38);
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
           background-color: rgba(255, 255, 255, 0.05);
         }
         #workspaces {
           padding-left: 0px;
           padding-right: 4px;
         }
         #workspaces button {
           padding-top: 0px;
           padding-bottom: 0px;
           padding-left: 1px;
           padding-right: 1px;
         }
         #workspaces button.active {
           background-color: rgba(255, 255, 255, 0.8);
           color: rgba(0, 0, 0, 1);
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
         tooltip label {
           color: rgb(217, 224, 238);
         }
	 #custom-clock, #network, #battery {
	   padding-left: 10px;
	   padding-right: 10px;
         }
         #workspaces button, #network, #custom-clock, #battery {
           color: rgba(255, 255, 255, 0.7);
         }
      '';
  };
}
