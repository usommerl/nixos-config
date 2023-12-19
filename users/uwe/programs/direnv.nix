{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    interactiveShellInit = ''
      set -gx DIRENV_LOG_FORMAT ""
    '';
  };
}
