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
  myHomePackages = map (pkg: pkgs.${pkg}) myHome.packages;
in
{
  imports = [ ./programs ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = myConfig.system.state_version;
    enableNixpkgsReleaseCheck = false;

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
    packages = with pkgs; [ wget ] ++ myHomePackages;

    #These two options below are automatically applied when nix flake rebuild is complete.
    sessionPath = [ ] ++ myHome.sessionPath;
    sessionVariables = {
      SHELL = "/etc/profiles/per-user/${userName}/bin/${myConfig.system.shell}";
    } // myHome.sessionVariables;

    #This is merged with the rc file of you selected shell and is not automatically reloaded. You can apply the rc file by "source" command or through the "reload" alias set in the configuration of each shell.(check out /home/programs/zsh/default.nix)
    shellAliases = { } // myHome.shellAliases;
  };
}
