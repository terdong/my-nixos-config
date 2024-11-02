{
  pkgs,
  pkgs-unstable,
  myConfig,
  #self,
  ...
}:

let
  userName = myConfig.user.name;
  ssh = myConfig.ssh;
#flakeRoot = self.outPath;
in
{
  programs.home-manager.enable = true;
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

    packages = with pkgs; [
      wget
      # curl
      # ripgrep
      # fd
      # tree
      # jq
      # httpie
      # htop
      # tmux
    ];

    # shellAliases = {
    # };
    # sessionVariables = {
    # };
  };
}
