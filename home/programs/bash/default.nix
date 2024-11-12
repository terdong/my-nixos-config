{ shellFunctions }:
{ pkgs, pkgs-unstable, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = "source ${shellFunctions}";
    shellAliases = {
      reload = "source $HOME/.bashrc";
    };
    package = pkgs-unstable.bash;
  };
}
