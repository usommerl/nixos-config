{ pkgs, config, lib, hyprland, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delte-older-than 2w";
    };
  };

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 15;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    tailscale
  ];

  networking.hostName = "ares";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font="Lat2-Terminus16";
    keyMap = "de";
  };

  services.tailscale.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  time.timeZone = "Europe/Berlin";
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.docker.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "23.05";
}

