{
  programs.wofi = {
    enable = true;

    settings = {
      key_down = "Control_L-n";
      key_up = "Control_L-p";
    };

    style = ''
      * {
        font-family: monospace;
      }

      #input > image.right {
        -gtk-icon-transform:scaleX(0);
      }
    '';
  };
}
