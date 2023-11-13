{ config, pkgs, lib, ... }:

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
  ];

  time.timeZone = "Europe/Berlin";


  networking.hostName = "ares";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font="Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "nodeadkeys";
    
    libinput.enable = true;
    displayManager.startx.enable = true;
    windowManager.awesome.enable = true;
  };

  services.printing.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.uwe = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  system.stateVersion = "23.05";
}

