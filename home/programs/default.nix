{ pkgs, myConfig, ... }:
let
  shellFunctions = pkgs.copyPathToStore ../resources/shell-functions;
in
{
  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  imports = [
    (import ./${myConfig.system.shell} { inherit shellFunctions; })
    ./git
    ./vim
    ./tmux
    #./nixvim
    #./nu
  ];

  xdg.configFile."containers/registries.conf".text =
    "
[registries.search]
registries = ['docker.io']

";
}
