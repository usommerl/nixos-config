{ pkgs, config, lib, hostName, mainUser, ... }:
with lib;
let
  mainUserMountConfig = ../../users/${mainUser}/mounts;
  plymouthTheme = "hexagon";
in
{
  imports =
    [
      ../../modules/system-nixos-label.nix
      ./hardware-configuration.nix
    ] ++ optional (builtins.pathExists mainUserMountConfig) mainUserMountConfig;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;

      substituters = [
        "https://walker.cachix.org"
      ];

      trusted-public-keys = [
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      ];
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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];

    # See:  
    # - https://github.com/NixOS/nixpkgs/pull/215693#issuecomment-1547809466
    # - https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/themes/adi1090x-plymouth-themes/shas.nix
    # - https://github.com/adi1090x/plymouth-themes?tab=readme-ov-file
    plymouth = {
      enable = true;
      theme = plymouthTheme;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [plymouthTheme];
        })
      ];
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 50;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  hardware = {
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          Experimental = true; # Showing battery charge of bluetooth devices
          Enable = "Source,Sink,Media,Socket"; # Enabling A2DP Sink
        };
      };
    };
  };

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    cifs-utils
    curl
    git
    google-drive-ocamlfuse
    neovim
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

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
    fuse.userAllowOther = true;
    hyprland.enable = true;
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    uid = 1000;
    shell = pkgs.fish;
  };

  system.useVcsInfoForLabel = true;
  system.stateVersion = "23.05";
}

