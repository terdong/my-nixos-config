{
  description = "A flake for scala project ";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";
  # 2024-11-09: latest nixpkgs has a bug that causes the vscode cannot start lsp with metals.
  #inputs.nixpkgsForGraal.url = "github:NixOS/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      #nixpkgsForGraal,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        #pkgsForGraalvm = nixpkgsForGraal.legacyPackages.${system};
        sbtWithGraalvm = pkgs.sbt.override { jre = pkgs.graalvmPackages.graalvm-ce; };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            packages = [ bashInteractive ];
            buildInputs = [
              graalvmPackages.graalvm-ce
              sbtWithGraalvm
            ];
          };
      }
    );
}
