{

  imports = [
    ./waybar.nix
    ./wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto

      # exec-once = waybar 

      # Set programs that you use
      $terminal = alacritty
      $fileManager = dolphin
      $menu = wofi --hide-scroll --insensitive --gtk-dark --prompt "" --show run
      # Some default env vars.
      env = XCURSOR_SIZE,24

      input {
          kb_layout = de
          kb_variant = nodeadkeys
          kb_model =
          kb_options =
          kb_rules =

  	  repeat_delay = 300
    	  repeat_rate = 50
      }

      general {
          gaps_in = 1
          gaps_out = 2
          border_size = 1
          col.active_border = rgba(ffcb6bee)
          col.inactive_border = rgba(00000000)

          layout = dwindle
          allow_tearing = false
      }

      decoration {
          rounding = 0

          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = true

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 3, myBezier
          animation = windowsOut, 1, 3, default, popin 80%
          animation = border, 1, 5, default
          animation = borderangle, 1, 3, default
          animation = fade, 1, 3, default
          animation = workspaces, 1, 1, default
      }

      dwindle {
          preserve_split = true # you probably want this
	  no_gaps_when_only = 1
      }

      misc {
          force_default_wallpaper = 0
          disable_hyprland_logo = true
      }

      windowrulev2 = nomaximizerequest, class:.* # You'll probably like this.

      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, RETURN, exec, $terminal
      bind = $mainMod SHIFT, C, killactive,
      bind = $mainMod, M, fullscreen, 0
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, Space, togglesplit, # dwindle
      bind = $mainMod, B, exec, pkill -SIGUSR1 '.*waybar.*' || waybar
      bind = $mainMod SHIFT, Pause, exec, systemctl suspend
      bind = $mainMod SHIFT CTRL, s, exec, poweroff

      # Move focus
      binde = $mainMod, h, movefocus, l
      binde = $mainMod, l, movefocus, r
      binde = $mainMod, k, movefocus, u
      binde = $mainMod, j, movefocus, d

      # Move window
      binde = $mainMod SHIFT, h, movewindow, l
      binde = $mainMod SHIFT, l, movewindow, r
      binde = $mainMod SHIFT, k, movewindow, u
      binde = $mainMod SHIFT, j, movewindow, d

      # Resize window
      binde = $mainMod CTRL, h, resizeactive, -10 0
      binde = $mainMod CTRL, l, resizeactive, 10 0
      binde = $mainMod CTRL, k, resizeactive, 0 -10
      binde = $mainMod CTRL, j, resizeactive, 0 10

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

      # "Hide" client by moving it to the special workspace
      bind = $mainMod, n, movetoworkspacesilent, special
      bind = $mainMod CTRL, n, togglespecialworkspace 
    '';
  };
}
