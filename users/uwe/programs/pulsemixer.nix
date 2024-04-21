{ pkgs, ... }:
with pkgs;
{
  home.packages = [ pulsemixer ];
  xdg.desktopEntries.pulsemixer = {
    name = "pulsemixer";
    genericName = "Audio Mixer";
    icon = "base";
    type = "Application";
    exec = "pulsemixer";
    terminal = true;
    startupNotify = false;
    categories = [ "Utility" ];
  };
}
