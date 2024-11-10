{ myConfig, myUtils, lib, ... }:

let
  userName = myConfig.user.name;
  activationScripts = {
     copyConfigToHome = import ./copyConfigToHome.nix { inherit myConfig; };
  } // lib.optionalAttrs myConfig.external.enabled {
    copyExternalFilesToHome = import ./copyExternalFilesToHome.nix { inherit myConfig myUtils; };
  };
in
{
  system.activationScripts = activationScripts;
}
