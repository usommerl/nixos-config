{ pkgs, config, ... }:
{

  imports = [
    ./waybar.nix
    ./walker.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto

      env = XCURSOR_SIZE,24
      env = XCURSOR_THEME,Adwaita
      exec-once = hyprctl setcursor Adwaita 24

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
      }

      misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
        background_color = 0x222436
      }

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = SUPER, RETURN, exec, alacritty --working-directory "$(hyprcwd)"
      bind = SUPER SHIFT, RETURN, exec, alacritty
      bind = SUPER SHIFT, C, killactive,
      bind = SUPER, M, fullscreen, 0
      bind = SUPER, E, exec, alacritty -e vifm
      bind = SUPER, V, togglefloating,
      bind = SUPER, P, pseudo, # dwindle
      bind = SUPER, Space, togglesplit, # dwindle
      bind = SUPER SHIFT, Pause, exec, systemctl suspend
      bind = SUPER SHIFT CTRL, s, exec, poweroff

      # Move focus
      binde = SUPER, h, movefocus, l
      binde = SUPER, l, movefocus, r
      binde = SUPER, k, movefocus, u
      binde = SUPER, j, movefocus, d

      # Move window
      binde = SUPER SHIFT, h, movewindow, l
      binde = SUPER SHIFT, l, movewindow, r
      binde = SUPER SHIFT, k, movewindow, u
      binde = SUPER SHIFT, j, movewindow, d

      # Resize window
      binde = SUPER CTRL, h, resizeactive, -10 0
      binde = SUPER CTRL, l, resizeactive, 10 0
      binde = SUPER CTRL, k, resizeactive, 0 -10
      binde = SUPER CTRL, j, resizeactive, 0 10

      # Switch workspaces with SUPER + [0-9]
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      # Move active window to a workspace with SUPER + SHIFT + [0-9]
      bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
      bind = SUPER SHIFT, 6, movetoworkspacesilent, 6
      bind = SUPER SHIFT, 7, movetoworkspacesilent, 7
      bind = SUPER SHIFT, 8, movetoworkspacesilent, 8
      bind = SUPER SHIFT, 9, movetoworkspacesilent, 9
      bind = SUPER SHIFT, 0, movetoworkspacesilent, 10

      # "Hide" client by moving it to the special workspace
      bind = SUPER, n, movetoworkspacesilent, special
      bind = SUPER CTRL, n, togglespecialworkspace
    '';
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    ( # hyprcwd script shamelessly stolen from https://github.com/vilari-mickopf/hyprcwd
      let
        name = "hyprcwd";
        buildInputs = with pkgs; [ hyprland jq procps coreutils-full ];
        script = pkgs.writeShellScriptBin name ''
          pid=$(hyprctl activewindow -j | jq '.pid')
          ppid=$(pgrep --newest --parent "$pid")
          dir=$(readlink /proc/"$ppid"/cwd || echo "$HOME")
          [ -d "$dir" ] && echo "$dir" || echo "$HOME"
        '';
      in pkgs.symlinkJoin {
        name = name;
        paths = [ script ] ++ buildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
      }
    )
  ];

  home.file."${config.xdg.dataHome}/icons/default/index.theme".text = ''
    [icon theme]
    Inherits=Adwaita
  '';
}
