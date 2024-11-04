{
  pkgs,
  pkgs-unstable,
  myConfig,
  ...
}:

let
  userName = myConfig.user.name;
  ssh = myConfig.ssh;
in
{
  imports = [ ./programs ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = myConfig.system.state_version;
    enableNixpkgsReleaseCheck = false;
    sessionVariables.SHELL = "/etc/profiles/per-user/${userName}/bin/${myConfig.system.shell}";
    file = {
      ".ssh/dummy" = {
        text = "dummy";
        recursive = true;
        onChange = "
        ssh_enabled=${toString ssh.enabled}
        private_key_path=${toString ssh.private_key_path}
        if [ $ssh_enabled ] && [ -f $private_key_path ]; then
          cp -rf $private_key_path $HOME/.ssh/id_rsa
          chmod 600 $HOME/.ssh/id_rsa
        fi
        ";
      };
    };

    #Set packages for your session.
    packages = with pkgs; [
      wget
      curl
      ripgrep
      tree
      jq
      httpie
      htop
      fd
      tmux
    ];

    #Set aliases for user session.
    # shellAliases = {
    # };

    #Set environment variables for user session.
    # sessionVariables = {
    # };
  };
}
