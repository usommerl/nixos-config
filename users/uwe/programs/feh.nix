{
  programs.feh = {

    enable = true;

    keybindings = {

      # unbind
      toggle_keep_vp = null;
      save_image = null;
      save_filelist = null;

      # menu bindings
      menu_parent = [ "h" "Left" ];
      menu_child = [ "l" "Right" ];
      menu_down = [ "j" "Down" ];
      menu_up = [ "k" "Up" ];
      menu_select = [ "space" "Return" ];

      # image navigation
      next_img = [ "J" "Right" "space" ];
      prev_img = [ "K" "Left" "BackSpace" ];

      # image movement
      scroll_up = [ "k" "C-Up" ];
      scroll_down = [ "j" "C-Down" ];
      scroll_left = [ "h" "C-Left" ];
      scroll_right = [ "l" "C-Right" ];

      # misc
      toggle_fullscreen = [ "f" ];
      zoom_in = [ "plus" "Up" ];
      zoom_out = [ "minus" "Down" ];
    };
  };
}
