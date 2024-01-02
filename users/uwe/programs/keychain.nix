{ lib, pkgs, ... }:
{
  programs.keychain = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.fish.interactiveShellInit = lib.mkBefore ''
    SHELL=fish eval (${pkgs.keychain}/bin/keychain --eval --quiet --nogui --ignore-missing id_rsa id_ed25519)
  '';
}
