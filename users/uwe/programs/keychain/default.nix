{
  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    extraFlags = [
      "--quiet"
      "--nogui"
      "--ignore-missing"
    ];
    keys = [
      "id_rsa"
      "id_ed25519"
    ];
  };
}
