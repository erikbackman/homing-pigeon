{
  description = "Homing Pigeon";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hasktorch.url = "github:hasktorch/hasktorch";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          allowBroken = true;
        };
        homingPigeon = import ./homing-pigeon.nix pkgs;
        
      in rec {
        
        packages = flake-utils.lib.flattenTree {
          inherit homingPigeon;
        };

        devShell = import ./shell.nix pkgs;
        
        defaultPackage = packages.homingPigeon;
      });
}
