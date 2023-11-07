{ config, pkgs, ... }:

{
  home.username = "uwe";
  home.homeDirectory = "/home/uwe";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    jq
    fzf
    viddy
    mtr
    btop
    usbutils
    lm_sensors
  ];

  home.file.".xinitrc".text = ''
    #!/bin/sh
    exec awesome
  '';
}

