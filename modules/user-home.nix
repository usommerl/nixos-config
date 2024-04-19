{ lib, config, ... }:
with lib; {
  options = {
    user = {
       username = mkOption {
         type = types.str;
         default = (strings.toLower (builtins.head (strings.splitString " " config.user.fullname)));
       };

       fullname = mkOption {
         type = types.str;
       };

       email = mkOption {
         type = types.str;
       };
    };
  };

  config = {
    home = {
      username = config.user.username;
      homeDirectory = "/home/" + config.user.username;
    };
  };
}
