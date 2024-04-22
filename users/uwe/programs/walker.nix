{ mainFontName, walker, ... }:
{

  imports = [
    walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = false;

    config = {
      placeholder = "";
      search = {
        hide_icons = false;
        hide_spinner = true;
      };

      fullscree = false;
      hyprland.context_aware_history = true;
      activation_mode.disabled = true;
      show_initial_entries = true;
      scrollbar_policy = "automatic";
      orientation = "vertical";

      runner.excludes = [
        "bash"
        "cd"
        "chroot"
        "fish"
        "rm"
        "rmdir"
        "sudo"
        "vifm"
        "vifm-pause"
        "vifm-convert-dircolors"
        "vifm-screen-split"
        "zsh"
      ];

      align = {
        ignore_exlusive = true;
        width = 400;
        horizontal = "center";
        vertical = "start";
        anchors = {
          top = false;
          left = false;
          bottom = false;
          right = false;
        };
        margins = {
          top = 0;
          bottom = 0;
          end = 0;
          start = 0;
        };
      };

      clipboard = {
        max_entries = 10;
        image_height = 300;
      };

      list = {
        height = 300;
        always_show = false;
        hide_sub = false;
      };

      icons = {
        theme = "";
        hide = false;
        size = 20;
        image_height = 200;
      };

      ignore_mouse = true;

      modules = [
        {
          name = "applications";
          prefix = "";
        }
        {
          name = "runner";
          prefix = "";
        }
        {
          name = "hyprland";
          prefix = "";
        }
        {
          name = "finder";
          prefix = "";
        }
        {
          name = "commands";
          prefix = "";
          switcher_exclusive = true;
        }
        {
          name = "switcher";
          prefix = "/";
        }
      ];
    };

    style = ''
      @define-color highlight-bg-color #2f3142;

      * {
        font-family: "${mainFontName}";
        color: #c8d3f5;
        background: rgba(0, 0, 0, 0.0);
      }

      #window {
      }

      #box {
        background: #161723;
        padding: 5px;
        border-radius: 0;
      }

      #searchwrapper {
      }

      #search,
      #typeahead {
        border-radius: 0;
        outline: none;
        outline-width: 0px;
        box-shadow: none;
        border-bottom: none;
        border: none;
        background: @highlight-bg-color;
        padding-left: 10px;
        padding-right: 10px;
        padding-top: 0px;
        padding-bottom: 0px;
        border-radius: 2px;
        margin-bottom: 5px;
      }

      #spinner {
        opacity: 0;
      }

      #spinner.visible {
        opacity: 1;
      }

      #typeahead {
        background: none;
        opacity: 0.5;
      }

      #search placeholder {
        opacity: 0.5;
      }

      #list {
      }

      row:selected {
        background: @highlight-bg-color;
      }

      .item {
        padding: 5px;
        border-radius: 2px;
      }

      .icon {
        padding-right: 10px;
      }

      .textwrapper {
      }

      .label {
      }

      .sub {
        opacity: 0.5;
      }

      .activationlabel {
        opacity: 0.25;
      }

      .activation .activationlabel {
        opacity: 1;
        color: #76946a;
      }

      .activation .textwrapper,
      .activation .icon,
      .activation .search {
        opacity: 0.5;
      }
    '';
  };

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = walker --gapplication-service
    bind = SUPER, R, exec, walker
  '';
}
