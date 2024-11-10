{
  pkgs,
  pkgs-unstable,
  myConfig,
  lib,
  ...
}:

let
  userName = myConfig.user.name;
  ssh = myConfig.ssh;
  aliases = myConfig.aliases;
  myHome = myConfig.home;
  myHomePackages = map (pkg: pkgs-unstable.${pkg}) myHome.packages;
in
{
  imports = [ ./programs ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = myConfig.system.state_version;
    enableNixpkgsReleaseCheck = false;

    file = {
      #Handling annoying .direnv: https://github.com/direnv/direnv/wiki/Customizing-cache-location
      ".config/direnv/direnvrc".source = ./resources/direnvrc;
    };

    #Set packages for your session.
    packages = with pkgs; [ wget ] ++ myHomePackages;

    #These two options below are automatically applied when nix flake rebuild is complete.
    sessionPath = [ ] ++ myHome.sessionPath;
    sessionVariables = {
      SHELL = "/etc/profiles/per-user/${userName}/bin/${myConfig.system.shell}";
    } // myHome.sessionVariables;

    #This is merged with the rc file of you selected shell and is not automatically reloaded. You can apply the rc file by "source" command or through the "reload" alias set in the configuration of each shell.(check out /home/programs/zsh/default.nix)
    shellAliases = {
      nixify = ''
        if [ ! -e ./.envrc ]; then
          echo 'use nix' > .envrc
          direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          echo "with import <nixpkgs> {};\nmkShell {\n  nativeBuildInputs = [\n    bashInteractive\n  ];\n}" > default.nix
          $EDITOR default.nix
        fi
      '';
      flakify = "
        if [ ! -e flake.nix ]; then
          nix flake new -t github:nix-community/nix-direnv .
        elif [ ! -e .envrc ]; then
          echo 'use flake' > .envrc
          direnv allow
        fi
        $EDITOR flake.nix
        ";
      scalafy = "
        if [ ! -e flake.nix ]; then
          cp $HOME/.config/nixos/home/resources/scalafy/flake.nix .
        fi
        if [ ! -e .envrc ]; then
          echo 'use flake' > .envrc
          direnv allow
        fi
      ";
    } // myHome.shellAliases;
  };
}
