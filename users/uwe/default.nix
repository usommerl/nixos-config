{ hyprland, pkgs, config, ... }:

{

  imports = [ 
    hyprland.homeManagerModules.default 
    ../../modules/user.nix
    ./programs
  ];

  user = {
    fullname = "Uwe Sommerlatt";
    email = "uwe.sommerlatt@gmail.com";
  };

  home.packages = with pkgs; [
    bat
    btop
    docker-compose
    du-dust
    google-chrome
    jq
    killall
    kubectl
    kubectx
    libreoffice
    lm_sensors
    mtr
    neovim
    (nerdfonts.override { fonts = [ "JetBrainsMono" "IBMPlexMono" ]; })
    ripgrep
    ugrep
    usbutils
    viddy
    wl-clipboard
  ];

  _module.args.mainFontName = "BlexMono Nerd Font";

  fonts.fontconfig.enable = true; 
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.stateVersion = "23.05";
}

