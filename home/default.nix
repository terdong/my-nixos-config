{
  self,
  pkgs,
  myConfig,
  ...
}:

let
  flakeRoot = self.outPath;
  userName = myConfig.user.name;
in
{
  programs.home-manager.enable = true;
  imports = [
    ./programs
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = myConfig.system.state_version;
    sessionVariables.SHELL = "/etc/profiles/per-user/${userName}/bin/${myConfig.system.shell}";
    file = {
      ".ssh/dummy" = {
        text = "dummy";
        onChange = "
        cp -rf ${myConfig.ssh.private_key_path} $HOME/.ssh/id_rsa
        chmod 600 $HOME/.ssh/id_rsa
        ";
      };
    };

    packages = with pkgs; [
      curl
      ripgrep
      fd
      tree
      jq
      wget
      httpie
      htop
      #tmux
    ];

    # shellAliases = {
    # };
    # sessionVariables = {
    #     EDITOR = myConfig.programs.editor;
    #     VISUAL = myConfig.programs.editor;
    # };
  };
}
