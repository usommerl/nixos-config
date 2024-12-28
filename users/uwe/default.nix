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
    bat
    btop
    calibre
    certigo
    docker-compose
    dogdns
    du-dust
    fio
    google-drive-ocamlfuse
    htop
    hyperfine
    httpie
    jq
    killall
    kubectl
    kubectx
    libreoffice
    lm_sensors
    mtr
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
    numbat
    p7zip
    remmina
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
  programs.nix-index.enable = true;

  home.stateVersion = "23.05";
}
