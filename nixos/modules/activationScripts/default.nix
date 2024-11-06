{ myConfig, ... }:

let
  userName = myConfig.user.name;
  activationScripts = {
    copyConfigToHome = import ./copyConfigToHome.nix { inherit myConfig; };
  };
in
{
  system.activationScripts = activationScripts;
}
