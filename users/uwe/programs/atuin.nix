{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    interactiveShellInit = ''
      bind \cp _atuin_search
      bind -M insert \cp _atuin_search
    '';
  };
}
