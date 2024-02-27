{ mainFontName, pkgs, config, ... }:
let
  lockCmd = "${pkgs.swaylock}/bin/swaylock --daemonize --config ${config.xdg.configHome}/swaylock/config";
in
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font = "${mainFontName}";
      font-size = 24;
      indicator-radius = 80;
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
