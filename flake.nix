{
  description = "Homing Pigeon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs-channels/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # hasktorch.url = "github:hasktorch/hasktorch";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        compiler = "ghc8107";

        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskellPackages;

        jailbreakUnbreak = pkg:
          pkgs.haskell.lib.doJailbreak (pkg.overrideAttrs (_: { meta = { }; }));

        packageName = "homing-pigeon";
      in
      {
        packages.${packageName} =
          haskellPackages.callCabal2nix packageName self rec {
            # Dependency overrides go here
          };

        defaultPackage = self.packages.${system}.${packageName};

        devShell = pkgs.mkShell {
          buildInputs = [
            haskellPackages.haskell-language-server
            haskellPackages.fourmolu
            haskellPackages.hpack
            haskellPackages.ghcid
            haskellPackages.cabal-install
            pkgs.nixpkgs-fmt
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };
      });
}
