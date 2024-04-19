{ self, nixpkgs, lib, config, ... }:
with lib;
let

  inherit (builtins) substring;
  inherit (self) sourceInfo;

  formatDate = s : "${substring 0 4 s}-${substring 4 2 s}-${substring 6 2 s}";
  formatTime = s : "${substring 8 2 s}:${substring 10 2 s}:${substring 12 2 s}Z";
  formatTimestamp = s : "${formatDate s}T${formatTime s}";

in {

  options.system.useVcsInfoForLabel =
    mkEnableOption "Use VCS information to create NixOS boot label";

  config = mkIf config.system.useVcsInfoForLabel {
    system.nixos.label = if sourceInfo ? shortRev
      then "${formatTimestamp sourceInfo.lastModifiedDate}.${sourceInfo.shortRev}-clean"
      else "${formatTimestamp sourceInfo.lastModifiedDate}.${sourceInfo.dirtyShortRev}";
  };
}
