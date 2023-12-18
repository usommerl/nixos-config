{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    shellAbbrs = {
      "z" = "zi";
      "Z" = "zi";
    };

    interactiveShellInit = ''
      set -xg _ZO_FZF_OPTS '-1 --reverse'
    '';
  };
}
