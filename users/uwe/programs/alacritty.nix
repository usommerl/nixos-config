{ mainFontName, pluginFromGitHub, ... }:
let
  # I need a more recent version that contains alacritty colorschemes in toml format
  tokyonight = (pluginFromGitHub "610179f7f12db3d08540b6cc61434db2eaecbcff" "main" "folke/tokyonight.nvim");
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "${tokyonight}/extras/alacritty/tokyonight_moon.toml"
      ];
      font.normal.family = "${mainFontName}";
      scrolling.history = 20000;
      window.padding = {
        x = 4;
        y = 4;
      };
    };
  };
}
