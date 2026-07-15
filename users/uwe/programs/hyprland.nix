{ pkgs, config, ... }:
{

  imports = [
    ./waybar.nix
    ./walker.nix
    ./dunst.nix
  ];

  wayland.windowManager.hyprland = {
    configType = "lua";
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      -- See https://wiki.hypr.land/Configuring/Basics/Monitors/
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

      -- Environment variables / cursor
      hl.env("XCURSOR_SIZE", "24")
      hl.env("XCURSOR_THEME", "Adwaita")
      hl.on("hyprland.start", function()
        hl.exec_cmd("hyprctl setcursor Adwaita 24")
      end)

      hl.config({
        input = {
          kb_layout = "de",
          kb_variant = "nodeadkeys",
          kb_model = "",
          kb_options = "",
          kb_rules = "",

          repeat_delay = 300,
          repeat_rate = 50,
        },

        general = {
          gaps_in = 1,
          gaps_out = 2,
          border_size = 1,
          col = {
            active_border = "rgba(ffcb6bee)",
            inactive_border = "rgba(00000000)",
          },

          layout = "dwindle",
          allow_tearing = false,
        },

        decoration = {
          rounding = 0,

          blur = {
            enabled = true,
            size = 3,
            passes = 1,

            vibrancy = 0.1696,
          },

          shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
          },
        },

        animations = {
          enabled = true,
        },

        dwindle = {
          preserve_split = true, -- you probably want this
        },

        misc = {
          force_default_wallpaper = 0,
          disable_hyprland_logo = true,
          background_color = 0x222436,
        },

        ecosystem = {
          no_update_news = true,
          no_donation_nag = true,
        },
      })

      -- Animation curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
      hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

      hl.animation({ leaf = "windows",     enabled = true, speed = 3, bezier = "myBezier" })
      hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
      hl.animation({ leaf = "border",      enabled = true, speed = 5, bezier = "default" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 3, bezier = "default" })
      hl.animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "default" })
      hl.animation({ leaf = "workspaces",  enabled = true, speed = 1, bezier = "default" })

      -- Replicate "smart gaps" / "no gaps when only" from other WMs/Compositors
      -- See: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/#smart-gaps
      hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
      hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
      hl.window_rule({
        name = "no-gaps-wtv1",
        match = { float = false, workspace = "w[tv1]" },
        border_size = 0,
        rounding = 0,
      })
      hl.window_rule({
        name = "no-gaps-f1",
        match = { float = false, workspace = "f[1]" },
        border_size = 0,
        rounding = 0,
      })

      -- Binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
      local mainMod = "SUPER"

      hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd('alacritty --working-directory "$(hyprcwd)"'))
      hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("alacritty"))
      hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
      hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("alacritty -e vifm"))
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
      hl.bind(mainMod .. " + SHIFT + Pause", hl.dsp.exec_cmd("systemctl suspend"))
      hl.bind(mainMod .. " + SHIFT + CTRL + s", hl.dsp.exec_cmd("poweroff"))

      -- Move focus
      hl.bind(mainMod .. " + j", hl.dsp.window.cycle_next(), { repeating = true })
      hl.bind(mainMod .. " + k", hl.dsp.window.cycle_next({ next = false }), { repeating = true })

      -- Move window
      hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }), { repeating = true })

      -- Resize window
      hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

      -- Switch workspaces with SUPER + [0-9]
      -- Move active window (silently) to a workspace with SUPER + SHIFT + [0-9]
      for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
      end

      -- "Hide" client by moving it to the special workspace
      hl.bind(mainMod .. " + n", hl.dsp.window.move({ workspace = "special", follow = false }))
      hl.bind(mainMod .. " + CTRL + n", hl.dsp.workspace.toggle_special())
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
