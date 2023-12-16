{
  description = "NixOS and home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ 
    self, 
    nixpkgs, 
    home-manager, 
    hyprland, ... 
  }: let 
    username = "uwe";
  in {
    nixosConfigurations = {

      ares = nixpkgs.lib.nixosSystem rec {
	system = "x86_64-linux";
	specialArgs = { inherit hyprland; };
	modules = [
	  ./system/configuration.nix
          home-manager.nixosModules.home-manager {
	    nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./users/${username};
	    home-manager.extraSpecialArgs = specialArgs;
          }
	];
      };
    };
  };
}
