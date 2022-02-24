{ compiler ? "ghc8107" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  gitignore = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];

  myHaskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      "homing-pigeon" =
        hself.callCabal2nix
          "homing-pigeon"
          (gitignore ./.)
          { };
    };
  };

  shell = myHaskellPackages.shellFor {
    packages = p: [
      p."homing-pigeon"
    ];
    buildInputs = [
      # Haskell tools
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.ghcid
      pkgs.haskellPackages.fourmolu
      pkgs.haskellPackages.hlint
      pkgs.haskellPackages.hpack

      # Haskell overrides
      myHaskellPackages.haskell-language-server

      # Nix tools
      pkgs.niv
      pkgs.nixpkgs-fmt
    ];
    withHoogle = true;
  };

  exe = pkgs.haskell.lib.justStaticExecutables (myHaskellPackages."homing-pigeon");

  docker = pkgs.dockerTools.buildImage {
    name = "homing-pigeon";
    config.Cmd = [ "${exe}/bin/homing-pigeon" ];
  };
in
{
  inherit shell;
  inherit exe;
  inherit docker;
  inherit myHaskellPackages;
  "homing-pigeon" = myHaskellPackages."homing-pigeon";
}
