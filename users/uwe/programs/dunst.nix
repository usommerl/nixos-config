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
        frame_color = "#000000";
        font = "${mainFontName} 11";
        show_indicators = "no";
        text_icon_padding = 15;
        horizontal_padding = 15;
        corner_radius = 5;
        gap_size = 8;
      };

      urgency_normal = {
        background = "#ffffff";
        foreground = "#000000";
        timeout = 10;
      };
    };
  };
}
