{
  description = "Flexible NixOS Configuration by Darren Kim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim = {
    #   url = "github:mikaelfangel/nixvim-config";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    #flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-wsl,
    #nixvim,
    #flake-utils,
    }:
    let
      myConfig = builtins.fromTOML (builtins.readFile ./my-config.toml);
      system = myConfig.system.name;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      myUtils = import ./lib/my-utils.nix { inherit pkgs; };
      userName = myConfig.user.name;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs-unstable;
          inherit myConfig;
          inherit myUtils;
        };

        modules = [
          (import ./nixos { inherit nixos-wsl; })
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit pkgs-unstable;
                inherit myConfig;
                #inherit nixvim;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userName} = ./home;
            };
          }
        ];
      };
    };
}
