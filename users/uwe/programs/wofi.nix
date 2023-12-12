{
  programs.wofi = {
    enable = true;

    settings = {
      key_down = "Control_L-n";
      key_up = "Control_L-p";
    };

    style = ''
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
