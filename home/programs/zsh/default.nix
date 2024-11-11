{ pkgs-unstable, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "node"
        "npm"
      ];
    };

    initExtra = "if [ -f /etc/static/bashrc ]; then source <(grep 'alias' /etc/static/bashrc); fi";

    shellAliases = {
      reload = "source $HOME/.zshrc";
    };
    package = pkgs-unstable.zsh;
  };
}
