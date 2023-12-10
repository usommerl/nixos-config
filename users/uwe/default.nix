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
    lm_sensors
    mtr
    neovim
    ripgrep
    ugrep
    usbutils
    xclip
    viddy
    zoxide
  ];

  programs.home-manager.enable = true;
  programs.starship.enable = true;
  programs.bash.enable = true;
  programs.alacritty.enable = true;
}

