{ hyprland, config, pkgs, ... }:

{

  imports = [ 
    hyprland.homeManagerModules.default 
    ./programs
  ];

  home = {
    username = "uwe";
    homeDirectory = "/home/uwe";
    stateVersion = "23.05";
  };

  fonts.fontconfig.enable = true; 

  home.packages = with pkgs; [
    bat
    btop
    direnv
    docker-compose
    du-dust
    google-chrome
    jq
    kubectl
    kubectx
    killall
    lm_sensors
    mtr
    neovim
    ripgrep
    ugrep
    usbutils
    xclip
    viddy
    zoxide
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.home-manager.enable = true;
  programs.bash.enable = true;
}

