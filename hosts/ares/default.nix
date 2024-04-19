{ pkgs, config, lib, hyprland, hostName, mainUser, ... }:
{
  imports =
    [
      ../../modules/system-nixos-label.nix
      ./hardware-configuration.nix
    ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;

      substituters = ["https://walker.cachix.org"];
      trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
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
      systemd-boot.configurationLimit = 50;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    cifs-utils
    curl
    git
    google-drive-ocamlfuse
    neovim
    pulsemixer
    tailscale
  ];

  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font="Lat2-Terminus16";
    keyMap = "de";
  };

  services = {
    getty.helpLine = lib.mkForce "" ;
    tailscale.enable = true;
    resolved.enable = true;
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "no";
    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    rtkit.enable = true; # Recommended for pipewire
    pam.services.swaylock = {};
    sudo.extraConfig = ''
      Defaults        timestamp_timeout=15
    '';
  };

  # See: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  time.timeZone = "Europe/Berlin";

  virtualisation.docker.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
  programs.fuse.userAllowOther = true;
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    uid = 1000;
    shell = pkgs.fish;
  };

  # TODO: Credentials file?
  fileSystems."/mnt/${mainUser}/harpocrates" = {
    device = "//harpocrates.tail15a8b.ts.net/homes/${mainUser}";
    fsType = "cifs";
    options =
      let
        uid = toString config.users.users.${mainUser}.uid;
      in
      [
        "noauto,x-systemd.automount"
        "x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
        "uid=${uid},gid=100,dir_mode=0700,file_mode=0600,nobrl"
        "credentials=/home/${mainUser}/.private/harpocrates"
      ];
  };

  system.useVcsInfoForLabel = true;
  system.stateVersion = "23.05";
}

