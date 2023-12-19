{ self, nixpkgs, ... }: let

  inherit (nixpkgs.lib) warn;
  inherit (builtins) substring;
  inherit (self) sourceInfo;

  formatDate = s : "${substring 0 4 s}-${substring 4 6 s}-${substring 6 8 s}";
  formatTime = s : "${substring 8 10 s}:${substring 10 12 s}:${substring 12 14 s}";
  formatTimestamp = s : "${formatDate s}T${formatTime s}";

in {

  system.nixos.label =
  if sourceInfo ? shortRev
  then "${formatTimestamp sourceInfo.lastModifiedDate}.${sourceInfo.shortRev}-clean"
  else warn "Repository is dirty!" "${formatTimestamp sourceInfo.lastModifiedDate}.${sourceInfo.dirtyShortRev}";

}
