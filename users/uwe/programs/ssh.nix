{ ... }:
with builtins;
let
  mkHostSettings = args : listToAttrs ( map (name: {
    inherit name;
    value = {
      HostName = "${name}.${args.domain}";
      User = args.user;
    };
  }) args.names );
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "harpocrates" = {
        HostName = "harpocrates.zebra-kitchen.ts.net";
        Port = 7022;
        User = "uwe";
        SetEnv = {
          TERM = "xterm";
        };
      };
    } // mkHostSettings {
      user = "uwe";
      domain = "zebra-kitchen.ts.net";
      names = [ "ares" "dolus" "eris" "nyx" "ceto-mac" ];
    } // mkHostSettings {
      user = "uwe.sommerlatt";
      domain = "exelonix.com";
      names = [
        "anvil"
        "truck"
        "topic"
        "billy"
        "lunar"
        "pablo"
        "basil"
      ];
    };
  };
}
