{ mainFontName, pkgs, config, hypridle, lib, ... }:
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

  imports = [
    hypridle.homeManagerModules.default
  ];

  services.hypridle = {
    enable = true;
    beforeSleepCmd = lockCmd;
    listeners = [
      {
        timeout = 600;
        onTimeout = lockCmd;
      }
    ];
  };

  wayland.windowManager.hyprland.extraConfig = mkIf config.wayland.windowManager.hyprland.enable ''
    bind = SUPER, Pause, exec, ${lockCmd}
  '';
}
