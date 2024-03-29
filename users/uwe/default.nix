{ pkgs, hyprland, hypridle, ... }:

{

  imports = [
    hyprland.homeManagerModules.default
    hypridle.homeManagerModules.default
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
    ugrep
    usbutils
    usql
    viddy
    wl-clipboard
    google-drive-ocamlfuse
  ];

  _module.args.mainFontName = "BlexMono Nerd Font";

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.stateVersion = "23.05";
}
