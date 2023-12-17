{ hyprland, pkgs, ... }:

{

  home = {
    username = "uwe";
    homeDirectory = "/home/uwe";
    stateVersion = "23.05";
  };

  imports = [ 
    hyprland.homeManagerModules.default 
    ./programs
  ];

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
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "IBMPlexMono" ]; })
  ];

  _module.args.mainFontName = "BlexMono Nerd Font";

  fonts.fontconfig.enable = true; 
  programs.home-manager.enable = true;
  programs.bash.enable = true;

}

