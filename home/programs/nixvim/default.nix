{ pkgs-unstable, nixvim, ... }:
{
  home = {
    packages = with pkgs-unstable; [ nixvim.packages.${system}.default ];
    shellAliases = {
      vi = "nvim";
    };
  };
}
