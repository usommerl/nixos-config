{ pluginFromGitHub, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = (pluginFromGitHub "2cd194d1033ba391d87d386735e15963adbc5f51" "v0.2.1" "mvllow/modes.nvim");
      type = "lua";
      config = ''
        require('modes').setup()
      '';
    }
  ];
}
