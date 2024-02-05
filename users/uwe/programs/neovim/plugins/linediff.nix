{ pluginFromGitHub, ... }:
{
  programs.neovim.plugins = [
    (pluginFromGitHub "245d16328c47a132574e0fa4298d24a0f78b20b0" "main" "AndrewRadev/linediff.vim")
  ];
}
