{ nixvim, ... }:
{
  imports = [ nixvim.homeManagerModules.nixvim ];
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
  home.shellAliases = {
    vi = "nvim";
  };
}
