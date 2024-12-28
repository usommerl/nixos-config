{ pkgs, mainFontName, ... }:
with pkgs;
{
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "${vimPlugins.tokyonight-nvim}/extras/alacritty/tokyonight_moon.toml"
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
