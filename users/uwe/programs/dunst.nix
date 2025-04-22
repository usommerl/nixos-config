{ mainFontName, ... }:
{
  services.dunst = {
    enable = true;

    settings = {
      global = {
        width = 500;
        transparency = 10;
        separator_height = 1;
        frame_width = 1;
        frame_color = "#eceff1";
        font = "${mainFontName} 11";
        show_indicators = "no";
        text_icon_padding = 15;
        horizontal_padding = 18;
        corner_radius = 5;
      };

      urgency_normal = {
        background = "#222436";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };
}
