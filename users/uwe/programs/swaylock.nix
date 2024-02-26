{ mainFontName, pkgs, config, ... }:
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

  services.hypridle = let
   lock = "${pkgs.swaylock}/bin/swaylock --daemonize --config ${config.xdg.configHome}/swaylock/config";
  in {
    enable = true;
    beforeSleepCmd = "${lock}";
    listeners = [
      {
        timeout = 600;
        onTimeout = "${lock}";
      }
    ];
  };
}
