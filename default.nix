{ compiler ? "ghc8107" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  gitignore = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];

  # TODO: if we want CUDA/OpenCL support we need to get this working
  # myArrayfire = pkgs.callPackage ./nix/arrayfire.nix {};

  myHaskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      "homing-pigeon" =
        hself.callCabal2nix
          "homing-pigeon"
          (gitignore ./.)
          { };
      "arrayfire" =
        let af = hself.callCabal2nix
          "arrayfire"
          sources.arrayfire-haskell
          {
            # af = myArrayfire;
            af = pkgs.arrayfire;
          };
        in
        pkgs.haskell.lib.overrideCabal af (drv: {
          configureFlags = (drv.configureFlags or [ ]) ++ [
            "-f disable-default-paths"
          ];
          extraLibraries = (drv.extraLibraries or [ ]) ++ [
            pkgs.arrayfire
          ];
          # Note: I would prefer to do the 'preCheck' but the tests fail...
          doCheck = false;
          # preCheck = ''
          #   export LD_LIBRARY_PATH=${pkgs.arrayfire}/lib:$LD_LIBRARY_PATH
          # '';
        });
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
      myHaskellPackages.arrayfire

      # Non-Haskell Dependencies
      pkgs.arrayfire
      pkgs.cmake

      # Nix tools
      pkgs.niv
      pkgs.nixpkgs-fmt
    ];
    withHoogle = true;
    shellHook = ''
      export LD_LIBRARY_PATH=${pkgs.arrayfire}/lib:$LD_LIBRARY_PATH
    '';
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
  # inherit myArrayfire;
  "homing-pigeon" = myHaskellPackages."homing-pigeon";
}
