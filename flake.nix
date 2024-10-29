{
  description = "Flexible NixOS Configuration by Darren Kim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nixvim,
    #flake-utils,
    }:
    let
      myConfig = builtins.fromTOML (builtins.readFile ./my-config.toml);
      system = myConfig.system.name;
      pkgs = nixpkgs.legacyPackages.${system};
      myUtils = import ./lib/my-utils.nix { inherit pkgs; };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit myConfig;
          inherit myUtils;
        };

        modules = [
          (import ./nixos { inherit nixos-wsl; })

          home-manager.nixosModules.home-manager
          {

            home-manager = {
              extraSpecialArgs = {
                inherit self;
                inherit myConfig;
                inherit nixvim;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.${myConfig.user.name} = ./home;
            };
          }
        ];
      };
    };
}
