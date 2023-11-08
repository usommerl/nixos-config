{
  description = "NixOS and home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {

      ares = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = inputs;
	modules = [
	  ./system/configuration.nix
          home-manager.nixosModules.home-manager {
	    nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.uwe = import ./users/uwe.nix;
          }
	];
      };
    };
  };
}
