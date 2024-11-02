{ myConfig, ... }:

{
  imports = [
    ./${myConfig.system.shell}
    ./git
    ./vim
    #./nixvim
    #./nu
  ];
}
