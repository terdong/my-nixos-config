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
    nixvim = {
      url = "github:mikaelfangel/nixvim-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
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
      nixvim,
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
                inherit nixvim;
                #inherit self;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userName} = ./home;
            };

            system.activationScripts.copyConfigToHome = {
              deps = [ "users" ];
              text = ''
                NIXOS_PATH="${myConfig.nixos.config_path}"

                if [ ! -d $NIXOS_PATH ]; then
                  exit 1
                fi

                SUDO_USER=${userName}
                BACKUP_DIR_NAME="${myConfig.nixos.backup_config_directory_name}"
                # Get the current user's home directory
                USER_HOME="/home/$SUDO_USER"
                if [ -z "$SUDO_USER" ]; then
                  USER_HOME=$HOME
                fi

                mkdir -p $USER_HOME/.dotfiles
                chown "$SUDO_USER:users" $USER_HOME/.dotfiles

                mkdir -p $USER_HOME/.config
                chown "$SUDO_USER:users" $USER_HOME/.config

                DESTINATION="$USER_HOME/.dotfiles/$BACKUP_DIR_NAME"
                DESTINATION_FOR_LINK="$USER_HOME/.config/$BACKUP_DIR_NAME"

                # Create backup directory if it doesn't exist
                mkdir -p $DESTINATION

                # Copy configuration files
                cp -r $NIXOS_PATH/* $DESTINATION
                chown -R "$SUDO_USER:users" $DESTINATION || true

                # Create symlink in .config for easier access (optional)
                mkdir -p "$USER_HOME/.config"
                ln -sfn $DESTINATION $DESTINATION_FOR_LINK || true
              '';
            };
          }
        ];
      };
    };
}
