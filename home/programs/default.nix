{ myConfig, ... }:

{
  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  imports = [
    ./${myConfig.system.shell}
    ./git
    ./vim
    ./tmux
    #./nixvim
    #./nu
  ];
}
