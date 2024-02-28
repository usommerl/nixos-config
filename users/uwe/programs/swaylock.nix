{ mainFontName, pkgs, config, ... }:
let
  swaylockPkg = pkgs.swaylock-effects;
  lockCmd = "${swaylockPkg}/bin/swaylock --daemonize --config ${config.xdg.configHome}/swaylock/config";

  white = "FFFFFFFF";
  black = "000000FF";
  darkGrey = "888888FF";
  yellow = "FFA000FF";
in
{
  programs.swaylock = {
    enable = true;
    package = swaylockPkg;
    settings = {
      color = black;
      ring-color = white;
      ring-clear-color = white;
      ring-caps-lock-color = white;
      ring-ver-color = white;
      ring-wrong-color = white;
      inside-clear-color = black;
      inside-ver-color = darkGrey;
      inside-wrong-color = yellow;
      text-caps-lock-color = yellow;
      text-clear-color = white;
      text-ver-color = white;
      bs-hl-color = darkGrey;
      key-hl-color = yellow;
      font = mainFontName;
      font-size = 20;
      indicator-radius = 80;
      indicator-thickness = 16;
      ignore-empty-password = true;
      text-ver = "";
    };
  };

  services.hypridle = {
    enable = true;
    beforeSleepCmd = "${lockCmd}";
    listeners = [
      {
        timeout = 600;
        onTimeout = "${lockCmd}";
      }
    ];
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      bind = SUPER, Pause, exec, ${lockCmd}
    '';
  };
}
