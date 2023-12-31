{ mainFontName, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "${mainFontName}";
      scrolling.history = 20000;
      window.padding = {
        x = 4;
        y = 4;
      };
    };
  };
}
