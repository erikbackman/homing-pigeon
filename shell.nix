pkgs: pkgs.mkShell {
  inputsFrom = [
    (import ./homing-pigeon.nix pkgs).env
  ];
  buildInputs = [
      # Haskell tools
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.ghcid
      pkgs.haskellPackages.fourmolu
      pkgs.haskellPackages.hlint
      pkgs.haskellPackages.hpack

      # Nix tools
      pkgs.nixpkgs-fmt
  ];
}
