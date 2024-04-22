{ pkgs, ... }:

{
  imports = [
    ../../modules/user-home.nix
    ./programs
  ];

  user = {
    fullname = "Uwe Sommerlatt";
    email = "uwe.sommerlatt@gmail.com";
  };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "IBMPlexMono" ]; })
    bat
    btop
    certigo
    docker-compose
    dogdns
    du-dust
    fio
    google-drive-ocamlfuse
    htop
    hyperfine
    jq
    killall
    kubectl
    kubectx
    libreoffice
    lm_sensors
    mtr
    numbat
    ripgrep
    signal-desktop
    ttyper
    ugrep
    usbutils
    usql
    viddy
    wl-clipboard
  ];

  _module.args.mainFontName = "BlexMono Nerd Font";

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.stateVersion = "23.05";
}
