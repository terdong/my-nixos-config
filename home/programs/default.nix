{ myConfig, ... }:

{
  imports = [
    ./git
    ./nixvim
    ./${myConfig.system.shell}
  ];
}
