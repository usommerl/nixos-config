{
  programs.wofi = {
    enable = true;

    settings = {
      key_down = "Control_L-n";
      key_up = "Control_L-p";
      width = 350;
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 10pt;
        font-weight: normal;
      }

      #input {
        box-shadow: none;
	border-radius: 0px;
      }

      #input > image.right {
        -gtk-icon-transform:scaleX(0);
      }
    '';
  };
}
