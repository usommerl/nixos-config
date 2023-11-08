{ config, pkgs, ... }:

{
  home.username = "uwe";
  home.homeDirectory = "/home/uwe";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ripgrep
    jq
    fzf
    viddy
    mtr
    btop
    usbutils
    lm_sensors
    google-chrome
  ];

  home.file.".xinitrc".text = ''
    #!/bin/sh
    exec awesome
  '';
}

