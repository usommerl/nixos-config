{ mainFontName, pkgs, config, lib, ... }:
with lib;
let
  swaylockPkg = pkgs.swaylock-effects;
  lockCmd = "${swaylockPkg}/bin/swaylock --daemonize --config ${config.xdg.configHome}/swaylock/config";

  white = "FFFFFFFF";
  black = "000000FF";
  grey = "666666FF";
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
      inside-clear-color = grey;
      inside-ver-color = grey;
      inside-wrong-color = yellow;
      text-caps-lock-color = yellow;
      text-clear-color = white;
      text-ver-color = white;
      bs-hl-color = grey;
      key-hl-color = yellow;
      font = mainFontName;
      font-size = 20;
      indicator-radius = 80;
      indicator-thickness = 16;
      ignore-empty-password = true;
      text-ver = "";
      text-clear = "";
      text-wrong = "";
      text-caps-lock = "CAPS LOCK";
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general.before_sleep_cmd = lockCmd;
      listener = [
        {
          timeout = 600;
          on-timeout = lockCmd;
        }
      ];
    };
  };

  wayland.windowManager.hyprland.extraConfig = mkIf config.wayland.windowManager.hyprland.enable ''
    bind = SUPER, Pause, exec, ${lockCmd}
  '';
}
