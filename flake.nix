{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {

      "ares" = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
	  ./system/configuration.nix
	];
      };

    };
  };
}
